defmodule Babygenius.Locality.FetchZipcodeFromDeviceApi do
  alias BabygeniusWeb.User

  @doc "Fetch zip code and country from API"
  @callback perform(user_id :: String.t(), request :: map()) :: {:ok, %User{}}
end