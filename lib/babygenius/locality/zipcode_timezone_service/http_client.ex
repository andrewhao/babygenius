defmodule Babygenius.Locality.ZipcodeTimezoneService.HttpClient do
  @behaviour Babygenius.Locality.ZipcodeTimezoneService

  alias Babygenius.Locality.Zipcode

  @base_url "https://zipgenius.herokuapp.com"

  def fetch_zipcode(zip) do
    url = "#{@base_url}/api/zipcodes/#{zip}"

    HTTPoison.get!(url)
    |> Map.get(:body)
    |> Poison.decode!()
    |> Map.get("zipcode")
    |> (fn zip_attrs -> struct(Zipcode, zip_attrs) end).()
  end

  def all_zipcodes() do
    url = "#{@base_url}/api/zipcodes"

    HTTPoison.get!(url)
    |> Map.get(:body)
    |> Poison.decode!()
    |> Map.get("zipcodes")
    |> Enum.map(fn zip_attrs -> struct(Zipcode, zip_attrs) end)
  end
end