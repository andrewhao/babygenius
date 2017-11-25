defmodule Babygenius.FetchTimezoneDataTest do
  use Babygenius.ModelCase
  import Babygenius.Factory
  import Mox
  alias Babygenius.{FetchTimezoneData}

  describe "perform/1" do
    setup do
      user = insert(:user)
      {:ok, user: user}
    end
    setup :verify_on_exit!

    test "queries the Device Address API and stores postal code in user", %{user: user} do
      expected_zip_code = "94105"

      Babygenius.AmazonDeviceService.Mock
      |> expect(:country_and_zip_code, fn(_device, _consent) -> %{"postalCode" => expected_zip_code} end)
      consent_token = "abcd"
      device_id = "1234"

      {:ok, result} = FetchTimezoneData.perform(user.id, device_id, consent_token)
      assert result.id == user.id
      assert result.zip_code == expected_zip_code
    end
  end
end
