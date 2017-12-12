defmodule Babygenius.Locality.FetchTimezone do
  @moduledoc """
  Task that checks the timezone for user in zip, and updates user
  if the timezone is valid.
  """
  alias BabygeniusWeb.User
  alias Babygenius.{Repo, Locality}

  @spec run(String.t(), %User{}) :: %User{}
  def run(zipcode, user) do
    Locality.get_zipcode!(zipcode)
    |> Map.get(:timezone)
    |> IO.inspect(label: "Timezone fetched is")
    |> (fn timezone -> User.changeset(user, %{timezone_identifier: timezone}) end).()
    |> Repo.update!()
  end
end
