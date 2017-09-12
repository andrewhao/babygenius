defmodule Babygenius.Factory do
  use ExMachina.Ecto, repo: Babygenius.Repo
  use Timex

  alias Babygenius.{User,DiaperChange}

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
end
