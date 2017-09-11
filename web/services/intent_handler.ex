defmodule Babygenius.IntentHandler do
  use Timex
  alias Babygenius.{User, DiaperChange, Repo}

  def handle_intent("AddDiaperChange", request, now \\ Timex.now()) do
    user_amazon_id = request.session.user.userId
    slots = request.request.intent.slots
    diaper_type = get_in(slots, ["diaperType", "value"])
    diaper_change_time = get_in(slots, ["diaperChangeTime", "value"])
    diaper_change_date = get_in(slots, ["diaperChangeDate", "value"])

    occurred_at = case diaper_change_time do
      nil -> now
      _ ->
        diaper_change_date_formatted = now |> Timex.format!("%Y-%m-%d", :strftime)
        Timex.parse!("#{diaper_change_date_formatted} #{diaper_change_time}", "%Y-%m-%d %H:%M", :strftime)
    end

    user = %User{amazon_id: user_amazon_id} |> User.find_or_create_by_amazon_id()
    %DiaperChange{
      user_id: user.id,
      type: diaper_type,
      occurred_at: occurred_at
    }
    |> Repo.insert!

    speak_date = case diaper_change_date do
      nil -> "today"
      _ ->
        parsed_date = Timex.parse!(diaper_change_date, "%Y-%m-%d", :strftime)
        day = parsed_date.day
        "#{Timex.format!(parsed_date, "%B", :strftime)} #{day}#{ordinal(day)}"
    end

    speak_time = occurred_at |> Timex.format!("%-I:%M %p", :strftime)
    speak_text = "A #{diaper_type} diaper change was logged #{speak_date} at #{speak_time}"

    %{speak_text: speak_text, should_end_session: true}
  end

  def ordinal(num) do
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
