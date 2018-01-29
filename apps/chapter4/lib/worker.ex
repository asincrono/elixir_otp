defmodule Chapter4 do
  use GenServer

  @moduledoc """
  Documentation for Chapter4.
  """

  # Client API.

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # Callbacks

  def init(:ok) do
    {:ok, %{}}
  end
end
