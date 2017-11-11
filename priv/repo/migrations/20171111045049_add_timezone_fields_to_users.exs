defmodule Babygenius.Repo.Migrations.AddTimezoneFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :timezone_identifier, :string, default: "Etc/UTC"
    end
  end
end
