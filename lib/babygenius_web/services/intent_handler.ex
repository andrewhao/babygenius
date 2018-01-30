defmodule BabygeniusWeb.IntentHandler do
  @moduledoc """
    Service module to handle incoming intents from Alexa Skills Kit
  """
  use Timex
  alias BabygeniusWeb.{User}
  alias Babygenius.{BabyLife, TimeUtils}
  use BabygeniusWeb, :model

  @locality_client Application.get_env(:babygenius, :locality_client)

  @spec handle_intent(clause :: String.t(), request :: map(), now :: DateTime.t()) :: map()
  def handle_intent(clause, request, now \\ Timex.now())

  def handle_intent("GetLastDiaperChange", request, now) do
    user = find_or_create_user_from_request(request)

    with {:ok, _} <- @locality_client.process_timezone_for_user(user.id, request),
         user_local_timezone <- @locality_client.get_timezone_for_user(user.id) do
      BabyLife.Client.get_last_diaper_change(user)
      |> last_diaper_change_text(user_local_timezone, now)
      |> (&%{speak_text: &1, should_end_session: true}).()
    end
  end

  def handle_intent("AddDiaperChange", request, now) do
    user = find_or_create_user_from_request(request)

    with {:ok, _} <- @locality_client.process_timezone_for_user(user.id, request),
         user_local_timezone <- @locality_client.get_timezone_for_user(user.id) do
      diaper_change_from_request(user, request, user_local_timezone, now)
      |> add_diaper_change_speech(user_local_timezone, now)
    end
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
    %User{amazon_id: user_amazon_id} |> User.find_or_create_by_amazon_id()
  end

  @spec diaper_change_from_request(
          user :: %User{},
          request :: map(),
          user_timezone :: String.t(),
          now :: DateTime.t()
        ) :: %BabyLife.DiaperChange{}
  defp diaper_change_from_request(user, request, user_timezone, now) do
    slots = request.request.intent.slots
    diaper_type = get_in(slots, ["diaperType", "value"])
    fetched_diaper_change_date = get_in(slots, ["diaperChangeDate", "value"])
    fetched_diaper_change_time = get_in(slots, ["diaperChangeTime", "value"])

    BabyLife.Client.create_diaper_change(
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
        ) :: map()
  defp add_diaper_change_speech(diaper_change, user_timezone, now) do
    time =
      diaper_change.occurred_at
      |> Timex.Timezone.convert(user_timezone)
      |> TimeUtils.formatted_time(now |> Timex.Timezone.convert(user_timezone))

    speak_text = "A #{diaper_change.type} diaper change was logged #{time}"

    %{speak_text: speak_text, should_end_session: true}
  end
end