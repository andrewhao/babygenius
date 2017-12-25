defmodule Babygenius.Locality do
  @moduledoc """
  The Locality context. This manages concerns around a user's location, and their
  associated implications around time zones.
  """

  import Ecto.Query, warn: false

  alias Babygenius.Repo
  alias Babygenius.Locality.{FetchTimezone, Setting}

  @spec fetch_timezone_by_zipcode_for_setting(String.t(), %Setting{}) :: {:ok, pid}
  def fetch_timezone_by_zipcode_for_setting(zipcode, setting) do
    Task.Supervisor.start_child(Babygenius.TaskSupervisor, fn ->
      FetchTimezone.run(zipcode, setting)
    end)
  end

  @doc """
  Gets a single setting.

  Raises `Ecto.NoResultsError` if the Setting does not exist.

  ## Examples

      iex> get_setting!(123)
      %Setting{}

      iex> get_setting!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_setting!(id :: String.t() | integer()) :: %Setting{}
  def get_setting!(id), do: Repo.get!(Setting, id)

  @spec create_setting(attrs :: map()) :: {:ok, %Setting{}}
  def create_setting(attrs) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_setting(%Setting{}, map()) :: {:ok, %Setting{}}
  def update_setting(%Setting{} = setting, attrs) do
    setting
    |> Setting.changeset(attrs)
    |> Repo.update()
  end
end