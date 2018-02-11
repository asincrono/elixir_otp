defmodule Chapter4 do
  use GenServer

  @name DS

  @moduledoc """
  Documentation for Chapter4.
  """

  # Client API.

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def get_temperature(location), do: GenServer.call(@name, {:location, location})

  def reset, do: GenServer.cast(@name, :reset_stats)

  def get_stats, do: GenServer.call(@name, :stats)

  def stop, do: GenServer.cast(@name, :stop)

  # Callbacks

  def init(:ok) do
    IO.puts("starting server: #{inspect(self())}")
    {:ok, %{}}
  end

  def handle_cast(:reset_stats, _stats) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, stats) do
    {:stop, :normal, stats}
  end

  def handle_call({:location, location}, _from, stats) do
    case get_temperature_from_ds(location) do
      {:ok, temp} ->
        new_stats = update_stats(stats, location, temp)
        {:reply, temp, new_stats}

      _ ->
        {:relpy, :error, stats}
    end
  end

  def handle_call(:stats, _from, stats), do: {:reply, {:ok, stats}, stats}

  def handle_info(msg, stats) do
    IO.puts("received #{inspect(msg)}")
    {:noreply, stats}
  end

  def terminate(reason, _stats) do
    IO.puts("I'm going down #{inspect(self())}, reason #{inspect(reason)}.")
    :ok
  end

  ## Helpers
  def get_location, do: %{lng: -8.5517524, lat: 42.8762276}

  defp get_ds_api_key, do: System.get_env("DARKSKY_API_KEY")

  defp url_for_location(%{lng: longitude, lat: latitude}) do
    "https://api.darksky.net/forecast/#{get_ds_api_key()}/#{latitude},#{longitude}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body}}) do
    %{"currently" => %{"temperature" => temperature}} = JSON.decode!(body)
    {:ok, %{temp: temperature, time: NaiveDateTime.utc_now()}}
  end

  def get_url_current(location) do
    url_for_location(location) <> "?exclude=minutely,hourly,daily,alerts,flags&units=si"
  end

  defp get_temperature_from_ds(location) do
    location
    |> get_url_current
    |> HTTPoison.get()
    |> parse_response
  end

  defp update_stats(stats, location, temp_info) do
    Map.update(stats, location, [temp_info], fn temps ->
      [temp_info | temps]
    end)
  end
end
