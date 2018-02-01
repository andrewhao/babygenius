defmodule Babygenius.ClientTest do
  use Babygenius.DataCase

  alias Babygenius.BabyLife

  setup do
    user = insert(:user)
    {:ok, user: user}
  end

  describe "feeding_events" do
    alias Babygenius.BabyLife.Feeding

    def feeding_fixture(attrs \\ %{}) do
      {:ok, feeding} =
        BabyLife.Client.create_feeding(%{
          user: attrs.user,
          feed_type: "some feed_type",
          unit: "MLs",
          volume: 60.0,
          time: "09:00",
          date: "2017-01-01"
        })

      feeding
    end

    test "create_feeding/2 with valid data creates a feeding", %{user: user} do
      assert {:ok, %Feeding{} = feeding} =
               BabyLife.Client.create_feeding(%{
                 user: user,
                 feed_type: "some feed_type",
                 unit: "MLs",
                 volume: 60.0,
                 time: "09:00",
                 date: "2017-01-01"
               })

      assert feeding.volume == 60.0
      assert feeding.feed_type == "some feed_type"
      assert feeding.unit == "MLs"
      assert feeding.occurred_at == Timex.to_datetime({{2017, 1, 1}, {9, 0, 0}}, "Etc/UTC")
    end

    test "change_feeding/1 returns a feeding changeset", %{user: user} do
      feeding = feeding_fixture(%{user: user})
      assert %Ecto.Changeset{} = BabyLife.Client.change_feeding(feeding)
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

      assert BabyLife.Client.list_events_for_user(user)
             |> Enum.map(&sort_by_attr/1) == [feed, dc] |> Enum.map(&sort_by_attr/1)
    end

    test "excludes events that do not correspond to user", %{user: user} do
      user2 = insert(:user)
      dc = insert(:diaper_change, user: user)
      insert(:diaper_change, user: user2)

      assert BabyLife.Client.list_events_for_user(user) |> Enum.map(&sort_by_attr/1) ==
               [dc] |> Enum.map(&sort_by_attr/1)
    end

    test "returns empty list if no matches found", %{user: user} do
      assert BabyLife.Client.list_events_for_user(user) == []
    end

    test "returns list reverse-ordered by occurrence date", %{user: user} do
      time1 = DateTime.utc_now() |> Timex.set(year: 2015)
      time2 = time1 |> Timex.set(year: 2016)
      time3 = time2 |> Timex.set(year: 2017)
      dc = insert(:diaper_change, user: user, occurred_at: time3)
      feeding = insert(:feeding, user: user, occurred_at: time2)
      feeding2 = insert(:feeding, user: user, occurred_at: time1)

      assert BabyLife.Client.list_events_for_user(user)
             |> Enum.map(&sort_by_attr/1) == [dc, feeding, feeding2] |> Enum.map(&sort_by_attr/1)
    end
  end

  defp sort_by_attr(struct) do
    [struct.id, struct.occurred_at]
  end
end