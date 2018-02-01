defmodule Babygenius.BabyLife.Behaviour do
  alias Babygenius.Identity.{User}
  alias Babygenius.BabyLife.{DiaperChange, Feeding}

  @callback create_diaper_change(
              user :: %User{},
              diaper_type :: String.t(),
              time :: String.t() | nil,
              date :: String.t() | nil,
              user_timezone :: String.t(),
              now :: DateTime.t()
            ) :: %DiaperChange{}

  @callback get_last_diaper_change(user :: %User{}) :: %DiaperChange{} | nil

  @callback create_feeding(
              %{
                user: %User{},
                feed_type: String.t(),
                volume: integer(),
                unit: String.t(),
                time: String.t() | nil,
                date: String.t() | nil
              },
              now :: DateTime.t()
            ) :: %Feeding{}

  @callback change_feeding(feeding :: %Feeding{}) :: %Ecto.Changeset{}

  @callback list_events_for_user(user :: %User{}) :: [%Feeding{} | %DiaperChange{} | nil]
end