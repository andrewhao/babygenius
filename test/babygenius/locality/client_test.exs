defmodule Babygenius.Locality.ClientTest do
  use Babygenius.DataCase

  alias Babygenius.Locality

  describe "settings" do
    alias Babygenius.Locality.Setting

    @valid_attrs %{user_id: "1", timezone_identifier: "America/Los_Angeles"}
    @update_attrs %{timezone_identifier: "America/Los_Angeles", zip_code: "94606"}
    @invalid_attrs %{}

    def setting_fixture(attrs \\ %{}) do
      {:ok, setting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Locality.Client.create_setting()

      setting
    end

    test "get_setting!/1 returns the setting with given id" do
      setting = setting_fixture()
      assert Locality.Client.get_setting!(setting.id) == setting
    end

    test "get_timezone_for_user/1 returns a user's timezone if it exists" do
      setting = setting_fixture()
      expected_timezone = "America/Los_Angeles"
      assert Locality.Client.get_timezone_for_user(setting.user_id) == expected_timezone
    end

    test "returns Etc/UTC if the user does not have an existing Setting" do
      expected_timezone = "Etc/UTC"
      assert Locality.Client.get_timezone_for_user("999") == expected_timezone
    end
  end
end
