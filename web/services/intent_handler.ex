defmodule Babygenius.IntentHandler do
  @moduledoc """
    Service module to handle incoming intents from Alexa Skills Kit
  """
  use Timex
  alias Babygenius.{User, DiaperChange, Repo, FetchTimezoneData}
  use Babygenius.Web, :model

  @spec handle_intent(clause :: String.t(), request :: map(), now :: DateTime.t()) :: map()

  def handle_intent(clause, request, now \\ Timex.now())

  def handle_intent("GetLastDiaperChange", request, _now) do
    user = find_or_create_user_from_request(request)

    {:ok, value} = FetchTimezoneData.perform(user.id, request)

    diaper_change =
      from(d in DiaperChange, where: d.user_id == ^user.id, order_by: d.occurred_at) |> last
      |> Repo.one()

    speak_text =
      case diaper_change do
        nil ->
          "You have not logged any diaper changes yet"

        _ ->
          "The last diaper change occurred #{formatted_time(diaper_change.occurred_at)}"
      end

    %{speak_text: speak_text, should_end_session: true}
  end

  def handle_intent("AddDiaperChange", request, now) do
    user = find_or_create_user_from_request(request)
    {:ok, value} = FetchTimezoneData.perform(user.id, request)

    diaper_change_from_request(user, request, now)
    |> Repo.insert!()
    |> diaper_change_speech
  end

  defp find_or_create_user_from_request(request) do
    user_amazon_id = request.session.user.userId
    %User{amazon_id: user_amazon_id} |> User.find_or_create_by_amazon_id()
  end

  defp diaper_change_from_request(user, request, now) do
    slots = request.request.intent.slots
    diaper_type = get_in(slots, ["diaperType", "value"])
    fetched_diaper_change_date = get_in(slots, ["diaperChangeDate", "value"])

    diaper_change_date =
      case fetched_diaper_change_date do
        nil ->
          now

        _ ->
          Timex.parse!(fetched_diaper_change_date, "%Y-%m-%d", :strftime)
      end

    fetched_diaper_change_time = get_in(slots, ["diaperChangeTime", "value"])

    diaper_change_time =
      case fetched_diaper_change_time do
        nil ->
          now

        _ ->
          diaper_change_date_formatted =
            diaper_change_date |> Timex.format!("%Y-%m-%d", :strftime)

          Timex.parse!(
            "#{diaper_change_date_formatted} #{fetched_diaper_change_time}",
            "%Y-%m-%d %H:%M",
            :strftime
          )
      end

    %DiaperChange{user_id: user.id, type: diaper_type, occurred_at: diaper_change_time}
  end

  defp diaper_change_speech(diaper_change) do
    speak_text =
      "A #{diaper_change.type} diaper change was logged #{
        formatted_time(diaper_change.occurred_at)
      }"

    %{speak_text: speak_text, should_end_session: true}
  end

  defp formatted_time(datetime) do
    now = Timex.now()

    speak_date =
      if now.day == datetime.day && now.month == datetime.month do
        "today"
      else
        day = datetime.day
        "#{Timex.format!(datetime, "%B", :strftime)} #{day}#{ordinal(day)}"
      end

    speak_time = datetime |> Timex.format!("%-I:%M %p", :strftime)

    "#{speak_date} at #{speak_time}"
  end

  defp ordinal(num) do
    cond do
      Enum.any?([11, 12, 13], &(&1 == Integer.mod(num, 100))) ->
        "th"

      Integer.mod(num, 10) == 1 ->
        "st"

      Integer.mod(num, 10) == 2 ->
        "nd"

      Integer.mod(num, 10) == 3 ->
        "rd"

      true ->
        "th"
    end
  end
end