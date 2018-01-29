defmodule Chapter3 do
  @moduledoc """
  Documentation for Chapter3.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Chapter3.hello
      :world

  """
  def hello do
    :world
  end

  def pong do
    receive do
      {:pong, pid} ->
        send(pid, {:ping, self()})

      {:stop, _pid} ->
        Process.exit(self(), :normal)

      unknown_msg ->
        IO.puts(
          "#{IO.inspect(self(), pretty: true)}: can't address message: #{
            IO.inspect(unknown_msg, pretty: true)
          }."
        )
    end

    pong()
  end

  def ping do
    receive do
      {:start, pid} ->
        send(pid, {:pong, self()})
        IO.puts("ping: starting.")

      {:stop, _} ->
        Process.exit(self(), :normal)

      {:ping, pid} ->
        send(pid, {:pong, self()})
        IO.puts("ping: pong received.")

      unknown_msg ->
        IO.puts(
          "#{IO.inspect(self(), pretty: true)}: can't address message: #{
            IO.inspect(unknown_msg, pretty: true)
          }."
        )
    end

    ping()
  end
end
