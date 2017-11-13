defmodule Babygenius.Repo.Migrations.AddConsentTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :consent_token, :string
    end
  end
end
