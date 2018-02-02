defmodule Babygenius.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Babygenius.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import BabygeniusWeb.Router.Helpers
      import Babygenius.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Babygenius.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Babygenius.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Babygenius.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end