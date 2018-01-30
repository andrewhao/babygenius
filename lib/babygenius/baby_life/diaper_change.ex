defmodule Babygenius.BabyLife.DiaperChange do
  @moduledoc """
  Repesentation of a Diaper Change event
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "diaper_changes" do
    field(:type, :string)
    field(:occurred_at, :utc_datetime)

    belongs_to(:user, BabygeniusWeb.User)

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :occurred_at, :user_id])
    |> validate_required([:type, :occurred_at, :user_id])
  end
end