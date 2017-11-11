defmodule Babygenius.Repo.Migrations.AddDeviceIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :device_id, :string
    end
  end
end
