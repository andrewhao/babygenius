defmodule Babygenius.IntentHandlerTest do
  use Babygenius.DataCase
  use Timex
  import Babygenius.Factory
  import Mox
  alias BabygeniusWeb.{IntentHandler}
  alias Babygenius.BabyLife.DiaperChange
  alias Babygenius.Identity.User

  setup :verify_on_exit!

  setup do
    Babygenius.Locality.Mock
    |> stub(:get_timezone_for_user, fn _user_id -> "America/Los_Angeles" end)

    {:ok, pass: "pass"}
  end

  describe "handle_intent/3 for GetLastDiaperChange" do
    setup do
      amazon_id = "amzn1.ask.account.SOME_ID"
      consent_token = "ConsentTokenValue"
      device_id = "DeviceIdValue"

      user = insert(:user, amazon_id: amazon_id)

      request_double = %{
        session: %{
          user: %{
            userId: amazon_id
          }
        },
        request: %{
          intent: %{
            slots: %{}
          }
        },
        context: %{
          System: %{
            apiAccessToken: "eyJ0e",
            application: %{applicationId: "amzn1.ask.skill.1175338a-99af-4093-80ab-3e9922f183f7"},
            device: %{
              deviceId: device_id
            },
            user: %{
              permissions: %{
                consentToken: consent_token
              },
              userId: "UserIdValue"
            }
          }
        }
      }

      Babygenius.Identity.Mock
      |> expect(:find_or_create_user_by_amazon_id, fn %User{
                                                        amazon_id: ^amazon_id,
                                                        consent_token: ^consent_token,
                                                        device_id: ^device_id
                                                      } ->
        user
      end)

      %{request: request_double, user: user}
    end

    test "informs about no diaper changes", %{request: request} do
      Babygenius.BabyLife.Mock
      |> expect(:get_last_diaper_change, fn _ -> nil end)

      response = IntentHandler.handle_intent("GetLastDiaperChange", request, Timex.now())
      assert response.speak_text == "You have not logged any diaper changes yet"
    end

    test "it reports a DiaperChange, shifting to account for local timezone", %{
      request: request,
      user: user
    } do
      # Today we logged a diaper change at 2:12 AM PST, which is 10:12 AM UTC
      # We query for this time at 7:00 PM UTC, or 11:00 AM PST
      today = Timex.now() |> Timex.set(month: 12, day: 15, hour: 10, minute: 12)
      today_now = Timex.now() |> Timex.set(month: 12, day: 15, hour: 19, minute: 0)

      Babygenius.BabyLife.Mock
      |> expect(:get_last_diaper_change, fn _ ->
        insert(:diaper_change, occurred_at: today, user: user)
      end)

      response = IntentHandler.handle_intent("GetLastDiaperChange", request, today_now)
      assert response.speak_text == "The last diaper change occurred today at 2:12 AM"
    end

    test "it reports a DiaperChange, shifting to account for local timezone past a day divider",
         %{
           request: request,
           user: user
         } do
      # Today we logged a diaper change at 2:12 AM PST, which is 10:12 AM UTC
      # We query for this time at 8:00 PM PST, or 4:00 AM UTC the next day
      today = Timex.now() |> Timex.set(month: 12, day: 1, hour: 10, minute: 12)
      today_now = Timex.now() |> Timex.set(month: 12, day: 2, hour: 4, minute: 0)

      Babygenius.BabyLife.Mock
      |> expect(:get_last_diaper_change, fn _ ->
        insert(:diaper_change, occurred_at: today, user: user)
      end)

      response = IntentHandler.handle_intent("GetLastDiaperChange", request, today_now)
      assert response.speak_text == "The last diaper change occurred today at 2:12 AM"
    end

    test "it reports the latest DiaperChange, shifting up to account for local timezone", %{
      request: request,
      user: user
    } do
      time_1 = Timex.now() |> Timex.set(year: 2020, month: 12, day: 25, hour: 12, minute: 30)

      Babygenius.BabyLife.Mock
      |> expect(:get_last_diaper_change, fn _ ->
        insert(:diaper_change, occurred_at: time_1, user: user)
      end)

      response = IntentHandler.handle_intent("GetLastDiaperChange", request, Timex.now())
      assert response.speak_text == "The last diaper change occurred December 25th at 4:30 AM"
    end
  end

  describe "handle_intent/2 for AddDiaperChange" do
    setup do
      amazon_id = "amzn1.ask.account.SOME_ID"

      request_double = %{
        session: %{
          user: %{
            userId: amazon_id
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
        },
        context: %{
          System: %{
            apiAccessToken: "eyJ0e",
            application: %{applicationId: "amzn1.ask.skill.1175338a-99af-4093-80ab-3e9922f183f7"},
            device: %{
              deviceId: "DeviceIdValue"
            },
            user: %{
              permissions: %{
                consentToken: "ConsentTokenValue"
              },
              userId: "UserIdValue"
            }
          }
        }
      }

      Babygenius.Identity.Mock
      |> expect(:find_or_create_user_by_amazon_id, fn %User{
                                                        amazon_id: amazon_id,
                                                        consent_token: "ConsentTokenValue",
                                                        device_id: "DeviceIdValue"
                                                      } ->
        insert(
          :user,
          amazon_id: amazon_id,
          consent_token: "ConsentTokenValue",
          device_id: "DeviceIdValue"
        )
      end)

      %{request: request_double, amazon_id: amazon_id}
    end

    test "it inserts a DiaperChange", %{request: request} do
      old_count = Repo.aggregate(from(dc in "diaper_changes"), :count, :id)
      IntentHandler.handle_intent("AddDiaperChange", request, Timex.now())
      new_count = Repo.aggregate(from(dc in "diaper_changes"), :count, :id)
      assert new_count == old_count + 1
    end

    test "it uses the current datetime if one is not given", %{request: request} do
      current_time = Timex.now()
      IntentHandler.handle_intent("AddDiaperChange", request, current_time)
      diaper_change = DiaperChange |> last |> Repo.one()

      assert diaper_change.occurred_at |> Map.put(:microsecond, 0) ==
               current_time |> Map.put(:microsecond, 0)
    end

    test "it uses provided date if one is given and shifts the time zone from local timezone to UTC",
         %{
           request: request
         } do
      # User wants to log diaper change at 19:00 PST, 2017-09-10
      # This converts to 02:00 UTC, 2017-09-11
      request =
        put_in(request, [:request, :intent, :slots, "diaperChangeTime"], %{
          "value" => "19:00"
        })
        |> put_in([:request, :intent, :slots, "diaperChangeDate"], %{"value" => "2017-09-10"})

      current_time = Timex.now()
      response = IntentHandler.handle_intent("AddDiaperChange", request, current_time)
      assert response.speak_text == "A wet diaper change was logged September 10th at 7:00 PM"

      saved_occurred_at =
        last(DiaperChange)
        |> Repo.one()
        |> Map.get(:occurred_at)

      # assert we persisted at UTC
      assert saved_occurred_at.hour == 2
      assert saved_occurred_at.day == 11
    end

    test "it uses the provided time if one is given, persisting in UTC (converting from local time)",
         %{request: request} do
      # The user specifies the diaper change to be logged for 9:00AM PST
      # Which converts to 5:00PM UTC
      request =
        put_in(request, [:request, :intent, :slots, "diaperChangeTime"], %{
          "value" => "09:00"
        })

      # Currently, it's 8:00PM UTC, or 12:00PM PST
      current_time = Timex.now() |> Timex.set(hour: 20, minute: 0, second: 0)

      response = IntentHandler.handle_intent("AddDiaperChange", request, current_time)

      saved_occurred_at =
        last(DiaperChange)
        |> Repo.one()
        |> Map.get(:occurred_at)

      # assert we persisted at UTC
      assert saved_occurred_at.hour == 17

      assert response.speak_text == "A wet diaper change was logged today at 9:00 AM"
    end

    test "it uses the provided time if one is given, persisting in UTC (converting from local time) even if UTC is into next day",
         %{request: request} do
      # The user specifies the diaper change to be logged for 9:00AM PST
      # Which converts to 5:00PM UTC
      request =
        put_in(request, [:request, :intent, :slots, "diaperChangeTime"], %{
          "value" => "09:00"
        })

      # Currently, it's 4:00AM UTC, or 8:00PM PST the prior day
      current_time = Timex.now() |> Timex.set(hour: 4, minute: 0, second: 0)

      response = IntentHandler.handle_intent("AddDiaperChange", request, current_time)

      saved_occurred_at =
        last(DiaperChange)
        |> Repo.one()
        |> Map.get(:occurred_at)

      # assert we persisted at UTC
      assert saved_occurred_at.hour == 17

      assert response.speak_text == "A wet diaper change was logged today at 9:00 AM"
    end
  end

  describe "handle_intent/2 for AddFeeding" do
    setup do
      amazon_id = "amzn1.ask.account.SOME_ID"

      occurred_at =
        Timex.now()
        |> Timex.set(year: 2017, month: 12, day: 25, hour: 12, minute: 0)

      feeding = insert(:feeding, feed_type: "feeding", occurred_at: occurred_at)
      request = Babygenius.AddFeedingRequestFixture.as_map()

      Babygenius.Identity.Mock
      |> expect(:find_or_create_user_by_amazon_id, fn %User{
                                                        device_id: "amzn1.ask.device.AH6U6HY6S",
                                                        consent_token: "eyJ0eXA"
                                                      } ->
        insert(:user)
      end)

      %{request: request, amazon_id: amazon_id, feeding: feeding}
    end

    test "it adds a feeding", %{request: request, feeding: feeding} do
      Babygenius.BabyLife.Mock
      |> expect(:create_feeding, fn %{user: _user}, _ ->
        {:ok, feeding}
      end)

      IntentHandler.handle_intent("AddFeeding", request, DateTime.utc_now())
    end

    test "it returns a confirmation message", %{request: request, feeding: feeding} do
      Babygenius.BabyLife.Mock
      |> stub(:create_feeding, fn _, _ -> {:ok, feeding} end)

      response = IntentHandler.handle_intent("AddFeeding", request, DateTime.utc_now())
      assert response.speak_text == "A feeding has been logged for December 25th at 4:00 AM"
    end
  end
end
