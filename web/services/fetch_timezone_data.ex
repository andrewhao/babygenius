defmodule Babygenius.FetchTimezoneData do
  def perform(device_id, consent_token) do
    url = "https://api.amazonalexa.com/v1/devices/#{device_id}/settings/address/countryAndPostalCode"
    headers = [{"Authorization", "Bearer #{consent_token}"}, {"Accept", "application/json"}]
    zip_code = Babygenius.AmazonDeviceService.country_and_zip_code(device_id, consent_token)
    |> Map.get("postalCode")
  end
end

