defmodule Babygenius.Locality.Setting do
  use Ecto.Schema
  import Ecto.Changeset
  alias Babygenius.Locality.Setting

  schema "locality_settings" do
    field(:user_id, :string)
    field(:zip_code, :string)
    field(:timezone_identifier, :string)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Setting{} = setting, attrs) do
    setting
    |> cast(attrs, [:user_id, :timezone_identifier, :zip_code])
    |> validate_required([:user_id])
  end
end