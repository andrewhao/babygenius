defmodule Babygenius.User do
  use Babygenius.Web, :model

  schema "users" do
    field :amazon_id, :string

    has_many :diaper_changes, Babygenius.DiaperChange
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:amazon_id])
    |> validate_required([:amazon_id])
  end
end
