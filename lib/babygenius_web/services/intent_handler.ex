defmodule BabygeniusWeb.IntentHandler do
  @moduledoc """
    Service module to handle incoming intents from Alexa Skills Kit
  """
  use Timex
  alias Babygenius.{BabyLife, Identity, TimeUtils}
  use BabygeniusWeb, :model

  @locality_client Application.get_env(:babygenius, :locality_client)
  @baby_life_client Application.get_env(:babygenius, :baby_life_client)

  @spec handle_intent(clause :: String.t(), request :: map(), now :: DateTime.t()) :: map()
  def handle_intent(clause, request, now \\ Timex.now()) do
    with user <- find_or_create_user_from_request(request),
         user_local_timezone <- @locality_client.get_timezone_for_user(user.id) do
      handle_intent_with_user_and_timezone(clause, request, now, user, user_local_timezone)
    end
  end

  def handle_intent_with_user_and_timezone(
        "GetLastDiaperChange",
        _request,
        now,
        user,
        user_local_timezone
      ) do
    BabyLife.get_last_diaper_change(user)
    |> last_diaper_change_text(user_local_timezone, now)
    |> (&%{speak_text: &1, should_end_session: true}).()
  end

  def handle_intent_with_user_and_timezone(
        "AddDiaperChange",
        request,
        now,
        user,
        user_local_timezone
      ) do
    diaper_change_from_request(user, request, user_local_timezone, now)
    |> add_diaper_change_speech(user_local_timezone, now)
    |> (&%{speak_text: &1, should_end_session: true}).()
  end

  def handle_intent_with_user_and_timezone("AddFeeding", request, now, user, user_local_timezone) do
    request
    |> extract_params_from_feeding_request(user)
    |> @baby_life_client.create_feeding(now)
    |> case do
      {:ok, feeding} ->
        feeding
        |> feeding_created_speech(user_local_timezone, now)

      {:error, _} ->
        "Uh oh"
    end
    |> (&%{speak_text: &1, should_end_session: true}).()
  end

  @spec feeding_created_speech(
          feeding :: %BabyLife.Feeding{},
          user_timezone :: String.t(),
          now :: DateTime.t()
        ) :: String.t()
  defp feeding_created_speech(feeding, user_timezone, now) do
    feeding_time =
      feeding
      |> Map.get(:occurred_at)
      |> Timex.Timezone.convert(user_timezone)
      |> TimeUtils.formatted_time(now |> Timex.Timezone.convert(user_timezone))

    "A #{feeding.feed_type} has been logged for #{feeding_time}"
  end

  @spec extract_params_from_feeding_request(request :: map(), user :: %Identity.User{}) :: %{
          user: %Identity.User{},
          feed_type: String.t(),
          volume: integer() | nil,
          unit: String.t() | nil,
          time: String.t() | nil,
          date: String.t() | nil
        }
  defp extract_params_from_feeding_request(request, user) do
    slots = request.request.intent.slots |> Morphix.atomorphiform!()
    feed_type = get_in(slots, [:feedName, :value])
    date = get_in(slots, [:feedDate, :value])
    time = get_in(slots, [:feedTime, :value])
    unit = get_in(slots, [:volumeUnit, :value])
    volume = get_in(slots, [:amount, :value])

    %{user: user, feed_type: feed_type, volume: volume, unit: unit, time: time, date: date}
  end

  @spec last_diaper_change_text(
          diaper_change :: %BabyLife.DiaperChange{} | nil,
          user_timezone :: String.t(),
          now :: DateTime.t()
        ) :: String.t()
  defp last_diaper_change_text(nil, _user_timezone, _now) do
    "You have not logged any diaper changes yet"
  end

  defp last_diaper_change_text(diaper_change, user_timezone, now) do
    change_time =
      diaper_change
      |> Map.get(:occurred_at)
      |> Timex.Timezone.convert(user_timezone)
      |> TimeUtils.formatted_time(now |> Timex.Timezone.convert(user_timezone))

    "The last diaper change occurred #{change_time}"
  end

  defp find_or_create_user_from_request(request) do
    user_amazon_id = request.session.user.userId

    %Identity.User{amazon_id: user_amazon_id}
    |> Identity.find_or_create_user_by_amazon_id()
  end

  @spec diaper_change_from_request(
          user :: %Identity.User{},
          request :: map(),
          user_timezone :: String.t(),
          now :: DateTime.t()
        ) :: %BabyLife.DiaperChange{}
  defp diaper_change_from_request(user, request, user_timezone, now) do
    slots = request.request.intent.slots
    diaper_type = get_in(slots, ["diaperType", "value"])
    fetched_diaper_change_date = get_in(slots, ["diaperChangeDate", "value"])
    fetched_diaper_change_time = get_in(slots, ["diaperChangeTime", "value"])

    BabyLife.create_diaper_change(
      user,
      diaper_type,
      fetched_diaper_change_time,
      fetched_diaper_change_date,
      user_timezone,
      now
    )
  end

  @spec add_diaper_change_speech(
          diaper_change :: %BabyLife.DiaperChange{},
          user_timezone :: String.t(),
          now :: DateTime.t()
        ) :: String.t()
  defp add_diaper_change_speech(diaper_change, user_timezone, now) do
    time =
      diaper_change.occurred_at
      |> Timex.Timezone.convert(user_timezone)
      |> TimeUtils.formatted_time(now |> Timex.Timezone.convert(user_timezone))

    "A #{diaper_change.type} diaper change was logged #{time}"
  end
end