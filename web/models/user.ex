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

  def find_or_create_by_amazon_id(user) do
    query = from u in Babygenius.User,
    where: u.amazon_id == ^user.amazon_id
    Babygenius.Repo.one(query) || Babygenius.Repo.insert!(user)
  end
end
