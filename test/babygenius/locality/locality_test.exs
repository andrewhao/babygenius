defmodule Babygenius.LocalityTest do
  use Babygenius.DataCase

  alias Babygenius.Locality

  describe "zipcodes" do
    alias Babygenius.Locality.Zipcode

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
end