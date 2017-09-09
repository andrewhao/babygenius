defmodule Babygenius.DiaperChange do
  use Babygenius.Web, :model

  schema "diaper_changes" do
    field :type, :string
    field :occurred_at, Timex.Ecto.DateTime

    belongs_to :user, Babygenius.User

    timestamps()
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
