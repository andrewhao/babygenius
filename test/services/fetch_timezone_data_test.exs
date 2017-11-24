defmodule Babygenius.FetchTimezoneDataTest do
  use Babygenius.ModelCase
  import Babygenius.Factory
  alias Babygenius.{FetchTimezoneData}

  describe "perform/1" do
    @tag :skip
    test "queries the Device Address API" do
      consent_token = "abcd"
      device_id = "1234"
      FetchTimezoneData.perform(device_id, consent_token)
    end
  end
end
