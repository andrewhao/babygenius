defmodule Babygenius.FetchZipcodeFromDeviceApi.LiveTest do
  use Babygenius.DataCase
  import Babygenius.Factory
  import Mox
  alias Babygenius.Locality.FetchZipcodeFromDeviceApi.{Live}
  alias Babygenius.Locality.{Setting}

  setup do
    consent_token = "abcd"
    device_id = "1234"
    user = insert(:user, consent_token: consent_token, device_id: device_id)

    Babygenius.Identity.Mock
    |> stub(:get_user_by_id, fn _ -> user end)

    expected_zip_code = "94105"

    BabygeniusWeb.AmazonDeviceService.Mock
    |> expect(:country_and_zip_code, fn ^device_id, ^consent_token ->
      %{"postalCode" => expected_zip_code}
    end)

    {:ok, user: user, expected_zip_code: expected_zip_code}
  end

  setup :verify_on_exit!

  describe "perform/2" do
    test "queries the Device Address API and stores postal code in setting", %{
      user: user,
      expected_zip_code: expected_zip_code
    } do
      {:ok, result} = Live.perform(user.id, fn _, _ -> nil end)
      saved_setting = Repo.all(Setting) |> List.last()
      assert result.zip_code == expected_zip_code
      assert saved_setting.zip_code == expected_zip_code
    end

    test "updates existing Setting if one already exists", %{
      user: user
    } do
      insert(:locality_setting, user_id: to_string(user.id))

      old_count = Repo.aggregate(from(p in "locality_settings"), :count, :id)

      {:ok, _result} = Live.perform(user.id, fn _, _ -> nil end)

      new_count = Repo.aggregate(from(p in "locality_settings"), :count, :id)

      assert old_count == new_count
    end
  end
end