defmodule Babygenius.Locality.ZipcodeTimezoneService do
  alias Babygenius.Locality.Zipcode

  @doc "Fetch timezone by zip code from ZipcodeGenius API"
  @callback fetch_zipcode(zip :: String.t()) :: %Zipcode{}

  @doc "Fetch all zipcodes by timezones from ZipcodeGenius API"
  @callback all_zipcodes() :: [%Zipcode{}]
end