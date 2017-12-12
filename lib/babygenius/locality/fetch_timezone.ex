defmodule Babygenius.Locality.FetchTimezone do
  @moduledoc """
  Task that checks the timezone for user in zip, and updates user
  if the timezone is valid.
  """
  use Task
  alias BabygeniusWeb.User
  alias Babygenius.{Repo, Locality}

  @spec start_link(String.t(), %User{}) :: {:ok, pid}
  def start_link(zipcode, user) do
    Task.start_link(__MODULE__, :run, [zipcode, user])
  end

  @spec run(String.t(), %User{}) :: %User{}
  def run(zipcode, user) do
    Locality.get_zipcode!(zipcode)
    |> Map.get(:timezone)
    |> IO.inspect(label: "Timezone fetched is")
    |> (fn timezone -> User.changeset(user, %{timezone_identifier: timezone}) end).()
    |> Repo.update!()
  end
end