defmodule Babygenius.LocalityTest do
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
        |> Locality.create_setting()

      setting
    end

    test "get_setting!/1 returns the setting with given id" do
      setting = setting_fixture()
      assert Locality.get_setting!(setting.id) == setting
    end
  end
end