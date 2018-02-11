defmodule Chapter5Test do
  use ExUnit.Case
  doctest Chapter5

  test "greets the world" do
    assert Chapter5.hello() == :world
  end
end
