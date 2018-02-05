defmodule Babygenius.Locality.Behaviour do
  @moduledoc """
  The interface to the Locality context boundary (client)
  """
  @callback get_timezone_for_user(user_id :: String.t()) :: String.t()
  @callback trigger_zipcode_lookup(String.t(), map()) :: {:ok, pid}
end