defmodule Babygenius.Locality.Behaviour do
  @moduledoc """
  The interface to the Locality context boundary (client)
  """
  alias Babygenius.Locality.Setting
  @callback get_timezone_for_user(user_id :: String.t()) :: String.t()
  @callback trigger_zipcode_lookup(String.t()) :: {:ok, pid}
  @callback get_setting_for_user(user_id :: String.t()) :: %Setting{} | nil
end
