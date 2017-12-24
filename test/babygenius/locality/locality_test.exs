defmodule Babygenius.LocalityTest do
  use Babygenius.DataCase

  alias Babygenius.Locality
  alias Locality.Zipcode

  import Mox

  setup do
    Locality.ZipcodeTimezoneService.Mock
    |> expect(:fetch_zipcode, fn zip ->
         %Zipcode{zip: zip, timezone: "America/Los_Angeles"}
       end)

    {:ok, mock: "installed"}
  end

  describe "zipcodes" do
    @valid_attrs %{zip: "94606", timezone: "America/Los_Angeles"}
    @update_attrs %{}
    @invalid_attrs %{}

    def zipcode_fixture(attrs \\ %{}) do
      {:ok, zipcode} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Locality.create_zipcode()

      zipcode
    end

    test "list_zipcodes/0 returns all zipcodes" do
      zipcode = zipcode_fixture()
      assert Locality.list_zipcodes() == [zipcode]
    end

    test "get_zipcode!/1 returns the zipcode with given id" do
      zipcode = zipcode_fixture()
      assert Locality.get_zipcode!(zipcode.zip) == zipcode
    end
  end

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