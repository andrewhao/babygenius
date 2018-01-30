defmodule Babygenius.TimeUtils do
  @moduledoc """
  A set of utilities meant to help format times and dates in a voice-friendly way
  """

  @spec utc_time_from_local_spoken_time(
          fetched_diaper_change_time :: String.t() | nil,
          fetched_diaper_change_date :: String.t() | nil,
          user_timezone :: String.t(),
          now :: %DateTime{}
        ) :: %DateTime{}
  def utc_time_from_local_spoken_time(
        fetched_diaper_change_time,
        fetched_diaper_change_date,
        user_timezone,
        now
      ) do
    # The date must be in the user timezone
    diaper_change_date =
      case fetched_diaper_change_date do
        nil ->
          now
          |> Timex.Timezone.convert(user_timezone)

        _ ->
          Timex.parse!(fetched_diaper_change_date, "%Y-%m-%d", :strftime)
      end

    case fetched_diaper_change_time do
      nil ->
        now

      _ ->
        diaper_change_date_formatted = diaper_change_date |> Timex.format!("%Y-%m-%d", :strftime)

        Timex.parse!(
          "#{diaper_change_date_formatted} #{fetched_diaper_change_time}",
          "%Y-%m-%d %H:%M",
          :strftime
        )
        |> DateTime.from_naive!("Etc/UTC")
        |> Timex.set(timezone: user_timezone)
        |> Timex.Timezone.convert("Etc/UTC")
    end
  end

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