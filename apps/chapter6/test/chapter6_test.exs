defmodule Chapter6Test do
  use ExUnit.Case
  doctest Chapter6

  test "greets the world" do
    assert Chapter6.hello() == :world
  end
end
