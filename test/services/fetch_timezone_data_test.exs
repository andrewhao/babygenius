defmodule Babygenius.FetchTimezoneDataTest do
  use Babygenius.ModelCase
  import Babygenius.Factory
  alias Babygenius.{FetchTimezoneData}

  describe "perform/1" do
    test "queries the Device Address API" do
      mock_response = %{"status" => "ok"}
      api_fn = fn(url) -> mock_response
      FetchTimezoneData.perform(device_id, consent_token, api_fn)
    end
  end
end
