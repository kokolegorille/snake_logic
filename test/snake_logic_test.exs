defmodule SnakeLogicTest do
  use ExUnit.Case
  doctest SnakeLogic

  test "greets the world" do
    assert SnakeLogic.hello() == :world
  end
end
