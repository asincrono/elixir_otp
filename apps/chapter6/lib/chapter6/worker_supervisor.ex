defmodule Chapter6.WorkerSupervisor do
  @moduledoc """
  Non me rompala cabeza.
  """
  use Supervisor

  # API
  #####
  # mfa -> module, function, args.
  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  # Callbacks
  ###########
  def init(_arg) do
    children = [
      Chapter6.SimpleWorker
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
