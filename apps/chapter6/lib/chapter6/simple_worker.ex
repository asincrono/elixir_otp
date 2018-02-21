defmodule Chapter6.SimpleWorker do
  @moduledoc """
  Simple worker module to use in the example. 
  """
  use GenServer, restart: :transient

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  # Callbacks
  def init(args) do
    {:ok, args}
  end
end
