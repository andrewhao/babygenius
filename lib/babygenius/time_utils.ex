defmodule Babygenius.TimeUtils do
  @moduledoc """
  A set of utilities meant to help format times and dates in a voice-friendly way
  """

  @spec formatted_time(datetime :: DateTime.t(), now :: DateTime.t()) :: String.t()
  def formatted_time(datetime, now \\ Timex.now()) do
    speak_date =
      if now.year == datetime.year && now.day == datetime.day && now.month == datetime.month do
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
