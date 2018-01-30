defmodule BabygeniusWeb.User do
  @moduledoc """
  DB representation of a user from Alexa
  """

  use BabygeniusWeb, :model
  alias BabygeniusWeb.{User}

  schema "users" do
    field(:amazon_id, :string)
    field(:timezone_identifier, :string)
    field(:device_id, :string)
    field(:consent_token, :string)
    field(:zip_code, :string)

    has_many(:diaper_changes, Babygenius.BabyLife.DiaperChange)
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:amazon_id, :timezone_identifier, :device_id, :consent_token, :zip_code])
    |> validate_required([:amazon_id, :timezone_identifier])
  end

  def find_or_create_by_amazon_id(user) do
    query = from(u in User, where: u.amazon_id == ^user.amazon_id)
    Babygenius.Repo.one(query) || Babygenius.Repo.insert!(user)
  end
end