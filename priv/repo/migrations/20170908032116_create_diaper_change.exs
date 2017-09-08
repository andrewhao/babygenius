defmodule Babygenius.Repo.Migrations.CreateDiaperChange do
  use Ecto.Migration

  def change do
    create table(:diaper_changes) do
      add :type, :string
      add :occurred_at, :naive_datetime, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end
    create index(:diaper_changes, [:user_id])
  end
end
