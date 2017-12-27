defmodule Babygenius.Repo.Migrations.UpdateDiaperChangeDatetimes do
  use Ecto.Migration

  def up do
    alter table(:diaper_changes) do
      remove(:occurred_at)
      add(:occurred_at, :utc_datetime, null: false)

      remove(:inserted_at)
      remove(:updated_at)
      timestamps(type: :utc_datetime)
    end
  end

  def down do
    alter table(:diaper_changes) do
      remove(:occurred_at)
      add(:occurred_at, :naive_datetime, null: false)

      timestamps(type: :naive_datetime)
    end
  end
end