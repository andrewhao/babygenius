defmodule Babygenius.Identity.UserTest do
  use Babygenius.DataCase

  alias Babygenius.Identity.User

  @valid_attrs %{
    amazon_id: "some content",
    timezone_identifier: "America/Los_Angeles",
    zip_code: "94105",
    device_id: "asdf"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "has many DiaperChanges" do
    user =
      User.changeset(%User{}, @valid_attrs)
      |> Repo.insert!()

    occurred_at = NaiveDateTime.utc_now()

    Ecto.build_assoc(user, :diaper_changes, occurred_at: occurred_at)
    |> Repo.insert!()

    assert user.amazon_id == "some content"
  end

  describe "#slugify" do
    test "loads hashid slug" do
      user = insert(:user)
      updated_user = user |> User.slugify()
      assert Regex.match?(~r/[\w]{3,}/, updated_user.slug)
    end
  end
end