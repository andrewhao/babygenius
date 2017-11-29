defmodule Babygenius.AmazonDeviceService do
  @doc "Fetch zip code and country from API"
  @callback country_and_zip_code(device_id :: String.t, consent_token :: String.t) :: map()
end
