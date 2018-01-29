defmodule Metex do
  @moduledoc """
  Documentation for Metex.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Metex.hello
      :world

  """
  def hello do
    :world
  end

  @doc """
  Will fetch temperatures of cities.
  """
  def temperatures_of(addresses) do
    coordinator_pid = spawn(Metex.Coordinator, :loop, [Enum.count(addresses)])

    Enum.each(addresses, fn address ->
      worker_pid = spawn(Metex.Worker, :loop, [])
      send(worker_pid, {coordinator_pid, address})
    end)
  end
end
