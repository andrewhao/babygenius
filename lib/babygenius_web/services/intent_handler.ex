defmodule BabygeniusWeb.IntentHandler do
  @moduledoc """
    Service module to handle incoming intents from Alexa Skills Kit
  """
  use Timex
  alias BabygeniusWeb.{User, DiaperChange, FetchTimezoneData}
  alias Babygenius.{Repo}
  use BabygeniusWeb, :model

  @spec handle_intent(clause :: String.t(), request :: map(), now :: DateTime.t()) :: map()
  def handle_intent(clause, request, now \\ Timex.now())

  def handle_intent("GetLastDiaperChange", request, _now) do
    user = find_or_create_user_from_request(request)

    with {:ok, _} <- FetchTimezoneData.perform(user.id, request) do
      from(d in DiaperChange, where: d.user_id == ^user.id, order_by: d.occurred_at)
      |> last
      |> Repo.one()
      |> last_diaper_change_text
      |> (&%{speak_text: &1, should_end_session: true}).()
    end
  end

  def handle_intent("AddDiaperChange", request, now) do
    user = find_or_create_user_from_request(request)

    with {:ok, _} <- FetchTimezoneData.perform(user.id, request) do
      diaper_change_from_request(user, request, now)
      |> Repo.insert!()
      |> diaper_change_speech
    end
  end

  @spec last_diaper_change_text(diaper_change :: nil) :: String.t()
  defp last_diaper_change_text(nil) do
    "You have not logged any diaper changes yet"
  end

  @spec last_diaper_change_text(diaper_change :: %DiaperChange{}) :: String.t()
  defp last_diaper_change_text(diaper_change) do
    "The last diaper change occurred #{formatted_time(diaper_change.occurred_at)}"
  end

  defp find_or_create_user_from_request(request) do
    user_amazon_id = request.session.user.userId
    %User{amazon_id: user_amazon_id} |> User.find_or_create_by_amazon_id()
  end

  @spec diaper_change_from_request(
          user :: %User{},
          request :: map(),
          now :: DateTime.t()
        ) :: %DiaperChange{}
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

  @spec diaper_change_speech(%DiaperChange{}) :: map()
  defp diaper_change_speech(diaper_change) do
    speak_text =
      "A #{diaper_change.type} diaper change was logged #{
        formatted_time(diaper_change.occurred_at)
      }"

    %{speak_text: speak_text, should_end_session: true}
  end

  @spec formatted_time(DateTime.t()) :: String.t()
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

  @spec ordinal(integer()) :: String.t()
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