defmodule Babygenius.Locality.ZipcodeTimezoneService.HttpClient do
  @behaviour Babygenius.Locality.ZipcodeTimezoneService

  alias Babygenius.Locality.Zipcode

  @base_url "https://zipgenius.herokuapp.com"
  @http_client_options [timeout: 50000, recv_timeout: 50000]
  @http_client_headers [Accept: "application/json"]

  @spec fetch_zipcode(zip :: String.t()) :: %Zipcode{}
  def fetch_zipcode(nil) do
    raise "No zip code provided!"
  end

  def fetch_zipcode(zip) do
    url = "#{@base_url}/api/zipcodes/#{zip}"

    HTTPoison.get!(url, @http_client_headers, @http_client_options)
    |> Map.get(:body)
    |> Poison.decode!()
    |> Map.get("zipcode")
    |> map_to_atoms
    |> (fn zip_attrs -> struct(Zipcode, zip_attrs) end).()
  end

  @spec all_zipcodes() :: [%Zipcode{}]
  def all_zipcodes() do
    url = "#{@base_url}/api/zipcodes"

    HTTPoison.get!(url, @http_client_headers, @http_client_options)
    |> Map.get(:body)
    |> Poison.decode!()
    |> Map.get("zipcodes")
    |> Enum.map(fn zip_attrs -> struct(Zipcode, map_to_atoms(zip_attrs)) end)
  end

  @spec map_to_atoms(map :: map()) :: map()
  defp map_to_atoms(map) do
    Enum.reduce(map, %{}, fn {key, val}, acc -> Map.put(acc, String.to_atom(key), val) end)
  end
end