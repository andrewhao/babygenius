defmodule Babygenius.Repo.Migrations.AlterUserConsentTokenSize do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :consent_token, :text
    end
  end
end
