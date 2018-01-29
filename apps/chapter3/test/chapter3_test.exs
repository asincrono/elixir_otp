defmodule Chapter3Test do
  use ExUnit.Case
  doctest Chapter3

  test "greets the world" do
    assert Chapter3.hello() == :world
  end
end
