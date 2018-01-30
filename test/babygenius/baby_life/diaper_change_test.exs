defmodule Babygenius.BabyLife.DiaperChangeTest do
  use Babygenius.DataCase

  alias Babygenius.BabyLife.DiaperChange

  @valid_attrs %{occurred_at: DateTime.utc_now(), type: "some content"}
  @invalid_attrs %{}

  setup do
    user = %BabygeniusWeb.User{amazon_id: "asdf"} |> Repo.insert!()
    {:ok, user: user}
  end

  test "changeset with valid attributes", context do
    valid_attrs = @valid_attrs |> Map.merge(%{user_id: context.user.id})
    changeset = DiaperChange.changeset(%DiaperChange{}, valid_attrs)

    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DiaperChange.changeset(%DiaperChange{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "casts occurred_at from non-UTC to UTC, but without shifting", %{user: user} do
    native_time =
      DateTime.utc_now()
      |> Timex.set(hour: 12, minute: 0, second: 0)
      |> Timex.Timezone.convert("America/Los_Angeles")

    assert native_time.hour == 4

    changeset =
      DiaperChange.changeset(%DiaperChange{}, %{
        occurred_at: native_time,
        type: "type",
        user_id: user.id
      })

    assert changeset.changes.occurred_at.time_zone == "Etc/UTC"
    assert changeset.changes.occurred_at.hour == 4
  end
end