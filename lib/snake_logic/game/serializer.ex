defmodule SnakeLogic.Game.Serializer do
  @moduledoc false
  
  alias SnakeLogic.Game.State

  def serialize(%State{} = game) do
    {width, height} = game.board_size
    %{board_size: [width, height],
      players: serialize_players(game)}
  end

  defp serialize_players(%State{} = game) do
    Enum.map(Map.keys(game.players), fn player_id ->
      # Poison encoder does not like interger key, transform to string first!
      {to_string(player_id), serialize_player(game, player_id)}
    end)
    |> Enum.into(%{})
  end

  defp serialize_player(%State{} = game, player_id) do
    {name, color, x, y, direction} = game.players[player_id]
    positions = case game.positions[player_id] do
      nil -> nil
      list -> Enum.map(list, fn {x, y} -> [x, y] end)
    end

    %{name: name,
      color: color,
      vector: [x, y, direction],
      positions: positions}
  end
end
