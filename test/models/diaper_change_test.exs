defmodule Babygenius.DiaperChangeTest do
  use Babygenius.DataCase

  alias BabygeniusWeb.DiaperChange

  @valid_attrs %{occurred_at: NaiveDateTime.utc_now(), type: "some content"}
  @invalid_attrs %{}

  setup do
    user = %BabygeniusWeb.User{amazon_id: "asdf"} |> Repo.insert!()
    {:ok, user: user}
  end

  test "changeset with valid attributes", context do
    valid_attrs = @valid_attrs |> Map.merge(%{user_id: context.user.id})

    # valid_attrs = %{occurred_at: NaiveDateTime.utc_now(), type: "some content", user_id: context.user.id}
    changeset = DiaperChange.changeset(%DiaperChange{}, valid_attrs)

    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DiaperChange.changeset(%DiaperChange{}, @invalid_attrs)
    refute changeset.valid?
  end
end