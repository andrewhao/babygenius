defmodule Babygenius.BabyLife.Feeding do
  use Ecto.Schema
  import Ecto.Changeset
  alias Babygenius.BabyLife.Feeding

  schema "feeding_events" do
    field(:volume, :float)
    field(:feed_type, :string)
    field(:occurred_at, :utc_datetime)
    field(:unit, :string)

    belongs_to(:user, Babygenius.Identity.User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Feeding{} = feeding, attrs) do
    feeding
    |> cast(attrs, [:feed_type, :unit, :volume, :occurred_at, :user_id])
    |> validate_required([:occurred_at, :user_id])
  end
end