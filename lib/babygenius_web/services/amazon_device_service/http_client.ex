defmodule BabygeniusWeb.AmazonDeviceService.HttpClient do
  @behaviour BabygeniusWeb.AmazonDeviceService

  def country_and_zip_code(device_id, consent_token) do
    url =
      "https://api.amazonalexa.com/v1/devices/#{device_id}/settings/address/countryAndPostalCode"

    headers = [{"Authorization", "Bearer #{consent_token}"}, {"Accept", "application/json"}]

    HTTPoison.get!(url, headers)
    |> Map.get(:body)
    |> Poison.decode!()
  end
end