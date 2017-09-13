defmodule Babygenius.IntentHandler do
  @moduledoc """
    Service module to handle incoming intents from Alexa Skills Kit
  """
  use Timex
  alias Babygenius.{User, DiaperChange, Repo}
  use Babygenius.Web, :model

  def handle_intent(intent_name, request, now \\ Timex.now()) do
    case intent_name do
      "GetLastDiaperChange" ->
        handle_intent_get_last_diaper_change(request, now)
      "AddDiaperChange" ->
        handle_intent_add_diaper_change(request, now)
    end
  end

  defp handle_intent_get_last_diaper_change(request, now) do
    user_amazon_id = request.session.user.userId
    user = Repo.get_by!(User, amazon_id: user_amazon_id)
    diaper_change = from(d in DiaperChange, where: d.user_id == ^user.id) |> last |> Repo.one
    speak_text = case diaper_change do
      nil ->
        "You have not logged any diaper changes yet"
      _ ->
        "The last diaper change occurred #{formatted_time(diaper_change.occurred_at)}"
    end

    %{speak_text: speak_text, should_end_session: true}
  end

  defp formatted_time(datetime) do
    speak_date = if Timex.now().day == datetime.day do
      "today"
    else
      day = datetime.day
      "#{Timex.format!(datetime, "%B", :strftime)} #{day}#{ordinal(day)}"
    end

    speak_time = datetime |> Timex.format!("%-I:%M %p", :strftime)

    "#{speak_date} at #{speak_time}"
  end

  defp handle_intent_add_diaper_change(request, now) do
    user_amazon_id = request.session.user.userId
    slots = request.request.intent.slots
    diaper_type = get_in(slots, ["diaperType", "value"])
    fetched_diaper_change_date = get_in(slots, ["diaperChangeDate", "value"])
    diaper_change_date = case fetched_diaper_change_date do
      nil -> now
      _ ->
        Timex.parse!(fetched_diaper_change_date, "%Y-%m-%d", :strftime)
    end

    fetched_diaper_change_time = get_in(slots, ["diaperChangeTime", "value"])
    diaper_change_time = case fetched_diaper_change_time do
      nil -> now
      _ ->
        diaper_change_date_formatted = diaper_change_date |> Timex.format!("%Y-%m-%d", :strftime)
        Timex.parse!("#{diaper_change_date_formatted} #{fetched_diaper_change_time}", "%Y-%m-%d %H:%M", :strftime)
    end

    user = %User{amazon_id: user_amazon_id} |> User.find_or_create_by_amazon_id()
    %DiaperChange{user_id: user.id, type: diaper_type, occurred_at: diaper_change_time} |> Repo.insert!

    speak_text = "A #{diaper_type} diaper change was logged #{formatted_time(diaper_change_time)}"

    %{speak_text: speak_text, should_end_session: true}
  end

  defp ordinal(num) do
    cond do
      Enum.any?([11, 12, 13], &(&1 == Integer.mod(num, 100))) ->
        "th"
      Integer.mod(num, 10) == 1 -> "st"
      Integer.mod(num, 10) == 2 -> "nd"
      Integer.mod(num, 10) == 3 -> "rd"
      true -> "th"
    end
  end
end
