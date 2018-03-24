defmodule SnakeLogic.Game do
  @moduledoc false
  
  alias SnakeLogic.Game.{State, Serializer}
  
  def new() do
    seed_random_number_generator()
    %State{}
  end
  
  def tally(state) do
    Serializer.serialize(state)
  end
  
  def join(state, player) do
    state 
    |> State.add_player(player, {player, get_random_color(), 0, 0, :up})
    |> State.spawn_player(player)
  end
  
  def leave(state, player) do
    state |> State.remove_player(player)
  end
  
  def handle_input(state, {player, action}) do
    state |> State.update_player_direction(player, action)
  end
  
  def tick(state) do
    state |> State.tick()
  end
  
  # Private
  
  defp seed_random_number_generator do
    <<a::size(32), b::size(32), c::size(32)>> = :crypto.strong_rand_bytes(12)
    :rand.seed(:exs1024, {a, b, c})
  end
  
  defp get_random_color do
    # Original javascript code here...
    # https://www.paulirish.com/2009/random-hex-color-code-snippets/
    #
    hexa_string = :rand.uniform(16777215) |> Integer.to_string(16)
    "#" <> hexa_string
  end
end