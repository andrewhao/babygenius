defmodule Babygenius.Repo.Migrations.CreateLocalitySettings do
  use Ecto.Migration

  def change do
    create table(:locality_settings) do
      add(:user_id, :string, null: false)
      add(:timezone_identifier, :string, default: "Etc/UTC")
      add(:zip_code, :string)

      timestamps(type: :utc_datetime)
    end
  end
end