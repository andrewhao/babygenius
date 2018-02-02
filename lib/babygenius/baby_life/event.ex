defmodule Babygenius.BabyLife.Event do
  @moduledoc """
  A struct that normalizes the differences between all different types of BabyLife events for presentation purposes
  """

  def create_from(source_event) do
    source_event |> Map.put(:event_type, source_event.__struct__)
  end
end