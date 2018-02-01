defmodule Babygenius.Repo.Migrations.CreateFeedingEvent do
  use Ecto.Migration

  def change do
    create table(:feeding_events) do
      add(:feed_type, :string)
      add(:unit, :string)
      add(:volume, :float)
      add(:occurred_at, :utc_datetime, null: false)
      add(:user_id, references(:users), null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:feeding_events, [:user_id]))
  end
end
