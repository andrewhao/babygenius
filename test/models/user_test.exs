defmodule Babygenius.UserTest do
  use Babygenius.ModelCase

  alias Babygenius.User

  @valid_attrs %{amazon_id: "some content"}
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
    user = User.changeset(%User{}, @valid_attrs)
    |> Repo.insert!
    occurred_at = NaiveDateTime.utc_now()

    diaper_changes_changeset = Ecto.build_assoc(user, :diaper_changes, occurred_at: occurred_at)
                                |> Repo.insert!

    assert user[:amazon_id] == "some content"
  end
end