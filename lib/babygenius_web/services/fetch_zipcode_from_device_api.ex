defmodule Babygenius.Locality.FetchZipcodeFromDeviceApi do
  alias Babygenius.Locality.Setting

  @doc "Fetch zip code and country from API"
  @callback perform(user_id :: String.t(), request :: map()) :: {:ok, %Setting{}}
end