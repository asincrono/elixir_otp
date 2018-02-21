defmodule Chapter6.WorkerDynamicSupervisor do
  @moduledoc """
  Frist try to use DynamicSupervisor.
  """
  use DynamicSupervisor

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def start_child do
    DynamicSupervisor.start_child(__MODULE__, Chapter6.SimpleWorker)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
