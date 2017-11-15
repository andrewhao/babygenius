defmodule Babygenius.FetchTimezoneData do
  def perform(device_id, consent_token, fetch_api_fn \\ HTTPoison.get/2) do
    url = "https://api.amazonalexa.com/v1/devices/#{device_id}/settings/address/countryAndPostalCode"
    fetch_api_fn.(url)
    # Accept: application/json
    # Authorization: Bearer MQEWY...6fnLok 
  end
end
