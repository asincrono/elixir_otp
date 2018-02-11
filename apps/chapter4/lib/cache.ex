defmodule Cache do
  use GenServer

  @moduledoc """
  GenServer cache that saves key, value pairs.
  """

  ## API
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def stop, do: GenServer.stop(__MODULE__)

  def write(key, value) do
    GenServer.cast(__MODULE__, {:store, {key, value}})
  end

  def read(key) do
    GenServer.call(__MODULE__, {:read, key})
  end

  def delete(key) do
    GenServer.cast(__MODULE__, {:delete, key})
  end

  def clear, do: GenServer.cast(__MODULE__, :clear)

  ## callbacks
  def init(args) do
    {:ok, args}
  end

  def terminate(reason, _state) do
    IO.puts("I'm going down cause #{inspect({reason})} (#{inspect(self())}).")
    :ok
  end

  def handle_call({:read, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_cast({:store, {key, value}}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_cast({:delete, key}, state) do
    {:noreply, Map.delete(state, key)}
  end

  def handle_cast(:clear, _state), do: {:noreply, %{}}

  def handle_info(msg, state) do
    IO.puts("Receive msg: #{inspect(msg)}")
    {:noreply, state}
  end
end
