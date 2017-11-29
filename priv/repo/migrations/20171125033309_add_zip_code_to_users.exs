defmodule Babygenius.Repo.Migrations.AddZipCodeToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :zip_code, :string
    end
  end
end
