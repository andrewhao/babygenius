defmodule Babygenius.BabyLife do
  @callback create_diaper_change(
              user :: %Babygenius.Identity.User{},
              diaper_type :: String.t(),
              time :: String.t() | nil,
              date :: String.t() | nil,
              user_timezone :: String.t(),
              now :: DateTime.t()
            ) :: %Babygenius.BabyLife.DiaperChange{}

  @callback get_last_diaper_change(user :: %Babygenius.Identity.User{}) ::
              %Babygenius.BabyLife.DiaperChange{} | nil
end