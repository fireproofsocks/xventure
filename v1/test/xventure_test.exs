defmodule XventureTest do
  use ExUnit.Case
  doctest Xventure

  test "greets the world" do
    assert Xventure.hello() == :world
  end
end
