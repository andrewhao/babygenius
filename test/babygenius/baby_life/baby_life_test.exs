defmodule Babygenius.BabyLifeTest do
  use Babygenius.DataCase

  alias Babygenius.BabyLife
  alias Babygenius.BabyLife.{DiaperChange}

  setup do
    user = insert(:user)
    now = Timex.now()

    {:ok,
     user: user,
     now: now,
     time: "09:00",
     date: "2017-01-01",
     user_timezone: "America/Los_Angeles",
     diaper_type: "Wet"}
  end

  describe "BabyLife.create_diaper_change/6" do
    test "it inserts a DiaperChange record", %{
      user: user,
      now: now,
      diaper_type: diaper_type,
      user_timezone: user_timezone
    } do
      old_count = Repo.aggregate(from(dc in "diaper_changes"), :count, :id)

      dc =
        BabyLife.create_diaper_change(
          user,
          diaper_type,
          nil,
          nil,
          user_timezone,
          now |> Timex.set(hour: 12, day: 25)
        )

      new_count = Repo.aggregate(from(dc in "diaper_changes"), :count, :id)
      assert old_count + 1 == new_count
      assert dc.type == diaper_type
      assert dc.id
    end

    test "it uses the current datetime if one is not given", %{
      user: user,
      now: now,
      diaper_type: diaper_type,
      user_timezone: user_timezone
    } do
      dc =
        BabyLife.create_diaper_change(
          user,
          diaper_type,
          nil,
          nil,
          user_timezone,
          now |> Timex.set(hour: 12, day: 25)
        )

      assert dc.occurred_at.hour == 12
      assert dc.occurred_at.day == 25
    end

    test "it uses provided date if one is given and shifts the time zone from local timezone to UTC",
         %{
           user: user,
           now: now,
           diaper_type: diaper_type,
           user_timezone: user_timezone
         } do
      # User wants to log diaper change at 19:00 PST, 2017-09-10
      # This converts to 02:00 UTC, 2017-09-11
      _dc =
        BabyLife.create_diaper_change(
          user,
          diaper_type,
          "19:00",
          "2017-09-10",
          user_timezone,
          now
        )

      saved_occurred_at =
        last(DiaperChange)
        |> Repo.one()
        |> Map.get(:occurred_at)

      # assert we persisted at UTC
      assert saved_occurred_at.hour == 2
      assert saved_occurred_at.day == 11
    end

    test "it uses the provided time if one is given, persisting in UTC (converting from local time)",
         %{
           user: user,
           diaper_type: diaper_type,
           user_timezone: user_timezone
         } do
      # Currently, it's 8:00PM UTC, or 12:00PM PST
      now = Timex.now() |> Timex.set(day: 14, hour: 20, minute: 0, second: 0)

      # The user specifies the diaper change to be logged for 9:00AM PST
      # Which converts to 5:00PM UTC
      _dc =
        BabyLife.create_diaper_change(
          user,
          diaper_type,
          "09:00",
          nil,
          user_timezone,
          now
        )

      saved_occurred_at =
        last(DiaperChange)
        |> Repo.one()
        |> Map.get(:occurred_at)

      # assert we persisted at UTC
      assert saved_occurred_at.hour == 17
      assert saved_occurred_at.day == now.day
    end

    test "it uses the provided time if one is given, persisting in UTC (converting from local time) even if UTC is into next day",
         %{
           user: user,
           diaper_type: diaper_type,
           user_timezone: user_timezone
         } do
      # Currently, it's 4:00AM UTC, or 8:00PM PST the prior day
      now = Timex.now() |> Timex.set(day: 14, hour: 4, minute: 0, second: 0)

      # The user specifies the diaper change to be logged for 9:00AM PST
      # Which converts to 5:00PM UTC
      _dc =
        BabyLife.create_diaper_change(
          user,
          diaper_type,
          "09:00",
          nil,
          user_timezone,
          now
        )

      saved_occurred_at =
        last(DiaperChange)
        |> Repo.one()
        |> Map.get(:occurred_at)

      # assert we persisted at UTC
      assert saved_occurred_at.hour == 17
      assert saved_occurred_at.day == now.day - 1
    end
  end

  describe "feeding_events" do
    alias Babygenius.BabyLife.Feeding

    def feeding_fixture(attrs \\ %{}) do
      {:ok, feeding} =
        BabyLife.create_feeding(%{
          user: attrs.user,
          feed_type: "some feed_type",
          unit: "MLs",
          volume: 60.0,
          time: "09:00",
          date: "2017-01-01",
          user_timezone: "America/Los_Angeles"
        })

      feeding
    end

    test "create_feeding/2 with valid data creates a feeding", %{user: user} do
      assert {:ok, %Feeding{} = feeding} =
               BabyLife.create_feeding(%{
                 user: user,
                 feed_type: "some feed_type",
                 unit: "MLs",
                 volume: 60.0,
                 time: "09:00",
                 date: "2017-01-01",
                 user_timezone: "America/Los_Angeles"
               })

      assert feeding.volume == 60.0
      assert feeding.feed_type == "some feed_type"
      assert feeding.unit == "MLs"
    end

    test "create_feeding/2 converts timezone to UTC timezone from user timezone", %{user: user} do
      assert {:ok, %Feeding{} = feeding} =
               BabyLife.create_feeding(%{
                 user: user,
                 feed_type: "some feed_type",
                 unit: "MLs",
                 volume: 60.0,
                 time: "09:00",
                 date: "2017-01-01",
                 user_timezone: "America/Los_Angeles"
               })

      assert feeding.occurred_at == Timex.to_datetime({{2017, 1, 1}, {17, 0, 0}}, "Etc/UTC")
    end

    test "change_feeding/1 returns a feeding changeset", %{user: user} do
      feeding = feeding_fixture(%{user: user})
      assert %Ecto.Changeset{} = BabyLife.change_feeding(feeding)
    end
  end

  describe "list_events_for_user/1" do
    setup do
      user = insert(:user)
      %{user: user}
    end

    test "returns a combined list of events for user", %{user: user} do
      dc = insert(:diaper_change, user: user)
      feed = insert(:feeding, user: user)

      assert BabyLife.list_events_for_user(user)
             |> Enum.map(&sort_by_attr/1) == [feed, dc] |> Enum.map(&sort_by_attr/1)
    end

    test "excludes events that do not correspond to user", %{user: user} do
      user2 = insert(:user)
      dc = insert(:diaper_change, user: user)
      insert(:diaper_change, user: user2)

      assert BabyLife.list_events_for_user(user) |> Enum.map(&sort_by_attr/1) ==
               [dc] |> Enum.map(&sort_by_attr/1)
    end

    test "returns empty list if no matches found", %{user: user} do
      assert BabyLife.list_events_for_user(user) == []
    end

    test "returns list reverse-ordered by occurrence date", %{user: user} do
      time1 = DateTime.utc_now() |> Timex.set(year: 2015, day: 15, hour: 10)
      time2 = time1 |> Timex.set(hour: 11)
      time3 = time2 |> Timex.set(hour: 12)
      time4 = time3 |> Timex.set(year: 2017, day: 1, hour: 1)
      feeding = insert(:feeding, user: user, occurred_at: time2)
      dc = insert(:diaper_change, user: user, occurred_at: time3)
      feeding2 = insert(:feeding, user: user, occurred_at: time1)
      dc2 = insert(:diaper_change, user: user, occurred_at: time4)

      assert BabyLife.list_events_for_user(user)
             |> Enum.map(&sort_by_attr/1) ==
               [dc2, dc, feeding, feeding2] |> Enum.map(&sort_by_attr/1)
    end
  end

  defp sort_by_attr(struct) do
    [struct.id, struct.occurred_at]
  end
end
