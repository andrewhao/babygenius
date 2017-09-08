defmodule Babygenius.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, comment: "User in our system") do
      add :amazon_id, :string, null: false, comment: "unique Amazon-assigned Alexa user identifier"

      timestamps()
    end

    create index(:users, [:amazon_id], unique: true)
  end
end
