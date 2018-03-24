# SnakeLogic

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `snake_logic` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:snake_logic, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/snake_logic](https://hexdocs.pm/snake_logic).

```elixir
iex(1)> g = SnakeLogic.Game.new
%SnakeLogic.Game.State{board_size: {120, 90}, players: %{}, positions: %{}}
iex(2)> g = SnakeLogic.Game.   
Serializer        State             handle_input/2    join/2            
leave/2           new/0             tally/1           tick/1            

iex(2)> g = g |> SnakeLogic.Game.join("koko")
%SnakeLogic.Game.State{
  board_size: {120, 90},
  players: %{"koko" => {"koko", "#83D30C", 67, 20, :up}},
  positions: %{"koko" => []}
}
iex(3)> g = g |> SnakeLogic.Game.join("kiki")
%SnakeLogic.Game.State{
  board_size: {120, 90},
  players: %{
    "kiki" => {"kiki", "#E3EE3F", 42, 40, :up},
    "koko" => {"koko", "#2445DC", 43, 77, :up}
  },
  positions: %{"kiki" => [], "koko" => []}
}
iex(4)> g = g |> SnakeLogic.Game.tick()       
%SnakeLogic.Game.State{
  board_size: {120, 90},
  players: %{
    "kiki" => {"kiki", "#E3EE3F", 42, 39, :up},
    "koko" => {"koko", "#2445DC", 43, 76, :up}
  },
  positions: %{"kiki" => [{42, 39}], "koko" => [{43, 76}]}
}
iex(5)> g |> SnakeLogic.Game.tally     
%{
  board_size: 'xZ',
  players: %{
    "kiki" => %{
      color: "#E3EE3F",
      name: "kiki",
      positions: ['*\''],
      vector: [42, 39, :up]
    },
    "koko" => %{
      color: "#2445DC",
      name: "koko",
      positions: ['+L'],
      vector: [43, 76, :up]
    }
  }
}
```