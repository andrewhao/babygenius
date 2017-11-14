defmodule Babygenius.FetchTimezoneDataTest do
  use Babygenius.ModelCase
  import Babygenius.Factory
  alias Babygenius.{FetchTimezoneData}

  describe "perform/1" do
    test "queries the Device Address API" do
      mock_response = %{"status" => "ok"}
      FetchTimezoneData.perform(fn -> mock_response)
    end
  end
end
