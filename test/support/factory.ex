defmodule Babygenius.Factory do
  use ExMachina.Ecto, repo: Babygenius.Repo
  use Timex

  alias Babygenius.Identity.{User}
  alias Babygenius.BabyLife.{DiaperChange, Feeding}

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
      occurred_at: DateTime.utc_now()
    }
  end

  def feeding_factory do
    %Feeding{
      user: build(:user),
      feed_type: "bottle",
      volume: 60.0,
      unit: "ml",
      occurred_at: DateTime.utc_now()
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
