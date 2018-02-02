defmodule Babygenius.BabyLife.EventTest do
  use Babygenius.DataCase
  alias Babygenius.BabyLife.{Event, DiaperChange, Feeding}

  describe "create_from/1" do
    test "diaper change wrapping" do
      christmas_day =
        DateTime.utc_now()
        |> Timex.set(year: 2017, month: 12, day: 25, hour: 12, minute: 34, second: 00)

      params = %{occurred_at: christmas_day, id: 999, type: "wet"}
      dc = struct(DiaperChange, params)

      event = Event.create_from(dc)

      assert event.occurred_at == params.occurred_at
      assert event.human_occurred_at == "Monday, 25 Dec 2017 12:34 PM"
      assert event.id == params.id
      assert event.event_name == "Diaper Change"
      assert event.event_type == "wet"
    end

    test "diaper change with shifted local timezone" do
      christmas_day =
        DateTime.utc_now()
        |> Timex.set(year: 2017, month: 12, day: 25, hour: 12, minute: 34, second: 00)

      params = %{occurred_at: christmas_day, id: 999}
      dc = struct(DiaperChange, params)

      event = Event.create_from(dc, "America/Los_Angeles")

      assert event.occurred_at == params.occurred_at
      assert event.human_occurred_at == "Monday, 25 Dec 2017  4:34 AM"
    end

    test "feeding wrapping" do
      christmas_day =
        DateTime.utc_now()
        |> Timex.set(year: 2017, month: 12, day: 25, hour: 12, minute: 34, second: 00)

      params = %{
        occurred_at: christmas_day,
        id: 999,
        feed_type: "nursed",
        volume: 60.0,
        unit: "ml"
      }

      feeding = struct(Feeding, params)

      event = Event.create_from(feeding)

      assert event.occurred_at == params.occurred_at
      assert event.human_occurred_at == "Monday, 25 Dec 2017 12:34 PM"
      assert event.id == params.id
      assert event.event_name == "Feeding"
      assert event.event_type == "nursed"
      assert event.event_details == "60.0 ml"
    end
  end
end