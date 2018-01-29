defmodule Metex.Worker do
  @moduledoc """
  Worker to fetch data from the web.
  """

  @doc """
  Returns info from the API.
  """
  def get_info(address) do
    info =
      address
      |> get_location
      |> url_for_location
      |> Enum.map(&HTTPoison.get(&1))
      |> Enum.map(&parse_info(&1))

    info
  end

  @doc """
  We generate an URL from the location info.
  """
  def url_for_location(locations) do
    now = NaiveDateTime.utc_now()

    start_time =
      now
      |> NaiveDateTime.add(-1800, :second)
      |> NaiveDateTime.truncate(:second)
      |> NaiveDateTime.to_iso8601()

    IO.puts(start_time)

    end_time =
      now
      |> NaiveDateTime.add(1800, :second)
      |> NaiveDateTime.truncate(:second)
      |> NaiveDateTime.to_iso8601()

    IO.puts(end_time)

    Enum.map(locations, fn location ->
      %{lng: lng, lat: lat} = location

      "http://servizos.meteogalicia.es/apiv3/getNumericForecastInfo?coords=#{lng},#{lat}&variables=temperature&startTime=#{
        start_time
      }&endTime=#{end_time}&API_KEY=#{get_api_key(:meteosix)}"
    end)
  end

  @doc """
  Return the API url from an address
  """
  def url_for_latitude(address) do
    p_address =
      address
      |> String.split()
      |> Enum.join("+")

    "https://maps.googleapis.com/maps/api/geocode/json?address=#{p_address}&key=#{
      get_api_key(:google_maps_geocoding)
    }"
  end

  @doc """
  Get the coordinates from Google Maps Geocoding.
  """
  def get_location(address) when is_binary(address) do
    %{"results" => results} =
      address
      |> url_for_latitude
      |> HTTPoison.get()
      |> parse_response

    Enum.map(results, fn location ->
      %{
        # "geometry" => %{"lng" => lng, "lat" => lat},
        "formatted_address" => address,
        "geometry" => %{"location" => %{"lng" => lng, "lat" => lat}}
      } = location

      # %{address: address, lng: lng, lat: lat}
      %{address: address, lng: lng, lat: lat}
    end)

    # %{"geomerty" => %{"location" => %{"lat" => lat, "lng" => lng}}} = body
    # %{lng: lng, lat: lat}
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body}}) do
    JSON.decode!(body)
  end

  defp parse_info({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    %{"features" => features} = JSON.decode!(body)

    features
    |> Enum.map(fn feature ->
      %{"properties" => %{"days" => days}} = feature
      List.first(days)
    end)
    |> Enum.map(fn day ->
      %{"variables" => variables} = day
      List.first(variables)
    end)
    |> Enum.map(fn variable ->
      IO.inspect(variable)
      %{"name" => name, "values" => values} = variable
      %{"value" => value} = List.first(values)
      %{name: name, value: value}
    end)
  end

  def loop do
    receive do
      {pid, address} ->
        send(pid, {:ok, get_info(address)})

      # To prevent message flood.
      _ ->
        IO.puts("Unknown message.")
    end

    loop()
  end

  def process(address_list) do
    Enum.map(address_list, fn address ->
      pid = spawn(Metex.Worker, :loop, [])
      send(pid, {self(), address})
    end)
  end

  defp get_api_key(:meteosix), do: System.get_env("METEOGALICIA_API_KEY")
  defp get_api_key(:google_maps_geocoding), do: System.get_env("GMG_API_KEY")
end
