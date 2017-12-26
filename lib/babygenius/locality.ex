defmodule Babygenius.Locality do
  @moduledoc """
  The interface to the Locality context boundary (client)
  """
  @callback get_timezone_for_user(user_id :: String.t()) :: String.t()
  @callback process_timezone_for_user(String.t(), map()) :: {:ok, pid}
end