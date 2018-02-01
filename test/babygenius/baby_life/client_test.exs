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

    end

    test "excludes events that do not correspond to user", %{user: user} do
    end
  end
end
