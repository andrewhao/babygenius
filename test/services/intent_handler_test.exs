defmodule Babygenius.IntentHandlerTest do
  use Babygenius.ModelCase
  use Timex
  import Babygenius.Factory
  alias Babygenius.{User, DiaperChange, IntentHandler}

  describe "handle_intent/3 for GetLastDiaperChange" do
    setup do
      amazon_id = "amzn1.ask.account.SOME_ID"
      user = insert(:user, amazon_id: amazon_id)
      request_double = %{
        session: %{
          user: %{
            userId: amazon_id
          }
        },
        request: %{
          intent: %{
            slots: %{
            }
          }
        }
      }
      %{request: request_double, user: user}
    end

    test "informs about no diaper changes", context do
      response = IntentHandler.handle_intent("GetLastDiaperChange", context.request)
      assert response.speak_text == "You have not logged any diaper changes yet"
    end

    test "it reports a DiaperChange", context do
      now = Timex.now() |> Timex.set([hour: 7, minute: 12])
      diaper_change = insert(:diaper_change, occurred_at: now, user: context.user)
      response = IntentHandler.handle_intent("GetLastDiaperChange", context.request)
      assert response.speak_text == "The last diaper change occurred today at 7:12 AM"
    end

    test "it reports the latest DiaperChange", context do
      time_1 = Timex.now() |> Timex.set([year: 2017, month: 12, day: 25, hour: 12, minute: 0])
      time_2 = time_1 |> Timex.shift(minutes: 30)
      insert(:diaper_change, occurred_at: time_1, user: context.user)
      insert(:diaper_change, occurred_at: time_2, user: context.user)
      response = IntentHandler.handle_intent("GetLastDiaperChange", context.request)
      assert response.speak_text == "The last diaper change occurred December 25th at 12:30 PM"
    end
  end

  describe "handle_intent/2 for AddDiaperChange" do
    setup do
      request_double = %{
        session: %{
          user: %{
            userId: "amzn1.ask.account.SOME_ID"
          }
        },
        request: %{
          intent: %{
            slots: %{
              "diaperType" => %{
                "value" => "wet"
              },
              "diaperChangeTime" => %{},
              "diaperChangeDate" => %{}
            }
          }
        }
      }
      %{request: request_double}
    end

    test "it inserts a DiaperChange", context do
      old_count = Repo.aggregate(from(dc in "diaper_changes"), :count, :id)
      IntentHandler.handle_intent("AddDiaperChange", context.request)
      new_count = Repo.aggregate(from(dc in "diaper_changes"), :count, :id)
      assert new_count == old_count + 1
    end

    test "it creates a user if one does not exist", context do
      old_count = Repo.aggregate(from(dc in "users"), :count, :id)
      IntentHandler.handle_intent("AddDiaperChange", context.request)
      new_count = Repo.aggregate(from(dc in "users"), :count, :id)
      assert new_count == old_count + 1
    end

    test "it uses the current datetime if one is not given", context do
      current_time = Timex.now()
      IntentHandler.handle_intent("AddDiaperChange", context.request, current_time)
      diaper_change = DiaperChange |> last |> Repo.one
      assert diaper_change.occurred_at == current_time
    end

    test "it uses provided date if one is given", context do
      request = put_in(
        context.request,
        [:request, :intent, :slots, "diaperChangeTime"],
        %{"value" => "19:00"}
      ) |> put_in(
        [:request, :intent, :slots, "diaperChangeDate"],
        %{"value" => "2017-09-10"}
      )
      current_time = Timex.now()
      response = IntentHandler.handle_intent("AddDiaperChange", request, current_time)
      assert response.speak_text == "A wet diaper change was logged September 10th at 7:00 PM"
    end

    test "it uses the provided time if one is given", context do
      request = put_in(
        context.request,
        [:request, :intent, :slots, "diaperChangeTime"],
        %{"value" => "19:00"}
      )
      current_time = Timex.now() |> Timex.set(hour: 12, minute: 0, second: 0)
      response = IntentHandler.handle_intent("AddDiaperChange", request, current_time)
      assert response.speak_text == "A wet diaper change was logged today at 7:00 PM"
    end
  end
end
