defmodule Babygenius.BabyLife.Event do
  @moduledoc """
  A struct that normalizes the differences between all different types of BabyLife events for presentation purposes
  """

  defstruct [:id, :occurred_at, :human_occurred_at, :event_type]

  alias Babygenius.BabyLife.{DiaperChange, Feeding, Event}

  @spec create_from(
          source_event :: %DiaperChange{} | %Feeding{},
          user_local_timezone :: String.t()
        ) :: %Event{}
  def create_from(source_event, user_local_timezone \\ "Etc/UTC") do
    human_occurred_at =
      source_event.occurred_at
      |> Timex.Timezone.convert(user_local_timezone)
      |> Timex.format!("%A, %d %b %Y %l:%M %p", :strftime)

    event_name =
      case source_event do
        %DiaperChange{} -> "Diaper Change"
        %Feeding{} -> "Feeding"
        _ -> "Unknown"
      end

    event_type =
      case source_event do
        %DiaperChange{} ->
          source_event.type

        %Feeding{} ->
          source_event.feed_type

        _ ->
          nil
      end

    Map.from_struct(source_event)
    |> (&struct(Event, &1)).()
    |> Map.put(:event_name, event_name)
    |> Map.put(:event_type, event_type)
    |> Map.put(:human_occurred_at, human_occurred_at)
  end
end