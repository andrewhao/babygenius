defmodule Babygenius.Factory do
  use ExMachina.Ecto, repo: Babygenius.Repo
  use Timex

  alias BabygeniusWeb.{User}
  alias Babygenius.BabyLife.{DiaperChange}

  alias Babygenius.Locality.Setting

  # Sample user factory
  def user_factory do
    %User{
      amazon_id: sequence(:email, &"testuser#{&1}@example.com")
    }
  end

  def diaper_change_factory do
    %DiaperChange{
      user: build(:user),
      type: "wet",
      occurred_at: Timex.now()
    }
  end

  def locality_setting_factory do
    %Setting{
      user_id: sequence(:user_id, &"user-#{&1}"),
      zip_code: nil,
      timezone_identifier: nil
    }
  end
end