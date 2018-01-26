defmodule BasicElixir do
  @moduledoc """
  Documentation for BasicElixir.
  """

  @doc """
  Hello world.

  ## Examples

      iex> BasicElixir.hello
      :world

  """
  def hello do
    :world
  end

  @doc """
  Adds a list of numbers together.
  """
  def sum([]), do: 0

  def sum([h | t]) when is_number(h) do
    h + sum(t)
  end

  @doc """
  Another way to sum.
  """
  def sum2(l) when is_list(l), do: do_sum2(0, l)

  defp do_sum2(acc, []), do: acc

  defp do_sum2(acc, [h | t]) when is_number(h) do
    do_sum2(acc + h, t)
  end

  def sum3(l) when is_list(l) do
    # Enum.reduce(l, &(&1 + &2))
    Enum.reduce(l, &+/2)
  end

  @doc """
  Transmforms a list of numbers into its squared reversed version.
  """
  def transform(l) when is_list(l), do: do_transform([], l)

  def do_transform(l_out, []), do: l_out

  def do_transform(l_out, [h | t]) do
    do_transform([h * h | l_out], t)
  end

  def transform2(l) when is_list(l) do
    Enum.map(Enum.reverse(l), &(&1 * &1))
  end

  def transform3(l) when is_list(l) do
    l
    |> Enum.reverse()
    |> Enum.map(&(&1 * &1))
  end
end
