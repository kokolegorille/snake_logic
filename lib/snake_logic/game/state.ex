defmodule SnakeLogic.Game.State do
  @moduledoc false
  
  defstruct board_size: {120, 90}, players: %{}, positions: %{}
  
  def add_player(state, player_id, {_name, _color, _x, _y, _direction} = player) do
    %{state | players: Map.put(state.players, player_id, player)}
  end

  def remove_player(state, player_id) do
    %{state |
      players: Map.delete(state.players, player_id),
      positions: Map.delete(state.positions, player_id)}
  end

  def spawn_player(state, player_id) do
    {width, height} = state.board_size
    {name, color, _, _, direction} = state.players[player_id]
    player = {name, color, round(:rand.uniform * width),
      round(:rand.uniform * height), direction}

    players = Map.put(state.players, player_id, player)
    %{state |
      players: players,
      positions: Map.put(state.positions, player_id, [])}
  end

  def update_player_direction(state, player_id, direction) do
    {name, color, x, y, _} = state.players[player_id]
    players = Map.put(state.players, player_id, {name, color, x, y, direction})
    %{state | players: players}
  end
  
  def tick(state) do
    positions = next_positions(state)
    events = calc_events(state, positions)
    apply_events(state, events, positions)
  end
  
  # Consider the game to be paused when there is no more spawned player
  def still_playable?(state) do
    state.positions |> Map.keys |> Enum.count > 0
  end

  defp next_positions(state) do
    Map.keys(state.positions)
    |> Enum.map(fn player_id ->
      player = state.players[player_id]
      {player_id, next_position(player)}
    end)
    |> Enum.into(%{})
  end
  
  defp next_position({_, _, x, y, direction}) do
    case direction do
      :up -> {x, y - 1}
      :right -> {x + 1, y}
      :down -> {x, y + 1}
      :left -> {x - 1, y}
      _ -> {x, y}
    end
  end

  defp calc_events(state, player_positions) do
    Enum.map(Map.keys(player_positions), fn player_id ->
      position = player_positions[player_id]
      if !inside_board?(state, position) || position_occupied?(state, position) do
        # || will be occupied
        {:died, player_id}
      else
        {:moved, player_id}
      end
    end)
  end

  defp apply_events(state, events, positions) do
    Enum.reduce(events, state, fn event, state ->
      case event do
        {:died, player_id} -> kill_player(state, player_id)
        {:moved, player_id} -> move_player(state, player_id, positions[player_id])
      end
    end)
  end
  
  defp kill_player(state, player_id) do
    %{state | positions: Map.delete(state.positions, player_id) }
  end
  
  defp move_player(state, player_id, {x, y} = position) do
    positions = update_in state.positions, [player_id], &([position | (&1 || [])])
    {name, color, _, _, direction} = state.players[player_id]
    %{state |
      players: Map.put(state.players, player_id, {name, color, x, y, direction}),
      positions: positions}
  end
  
  defp inside_board?(state, {x, y}) do
    {width, height} = state.board_size
    x >= 0 && x < width && y >= 0 && y < height
  end
  
  defp position_occupied?(state, position) do
    Enum.any?(Map.values(state.positions), fn positions ->
      Enum.any?(positions, &(&1 == position))
    end)
  end
end