defmodule Babygenius.Identity.User do
  @moduledoc """
  DB representation of a user from Alexa
  """

  use BabygeniusWeb, :model
  alias Babygenius.Identity.HashidGenerator

  schema "users" do
    field(:amazon_id, :string)
    field(:timezone_identifier, :string)
    field(:device_id, :string)
    field(:consent_token, :string)
    field(:zip_code, :string)
    field(:slug, :string, virtual: true)

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

  @spec slugify(user :: %Babygenius.Identity.User{}) :: %Babygenius.Identity.User{
          slug: String.t()
        }
  def slugify(user) do
    user |> Map.put(:slug, generate_slug(user.id))
  end

  defp generate_slug(user_id) do
    HashidGenerator.encode([user_id])
  end
end