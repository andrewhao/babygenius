defmodule Babygenius.Locality do
  @moduledoc """
  The Locality context. This manages concerns around a user's location, and their
  associated implications around time zones.
  """

  @behaviour Babygenius.Locality.Behaviour

  alias Babygenius.Repo
  alias Babygenius.Locality.{FetchTimezone, Setting, FetchZipcodeFromDeviceApi}

  @impl true
  def trigger_zipcode_lookup(user_id) do
    Task.Supervisor.start_child(Babygenius.TaskSupervisor, fn ->
      FetchZipcodeFromDeviceApi.Live.perform(user_id)
    end)
  end

  @impl true
  def get_timezone_for_user(user_id) do
    case Repo.get_by(Setting, user_id: to_string(user_id)) do
      nil -> "Etc/UTC"
      setting -> setting.timezone_identifier
    end
  end

  @spec fetch_timezone_by_zipcode_for_setting(String.t(), %Setting{}) :: {:ok, pid}
  def fetch_timezone_by_zipcode_for_setting(zipcode, setting) do
    Task.Supervisor.start_child(Babygenius.TaskSupervisor, fn ->
      FetchTimezone.run(zipcode, setting)
    end)
  end

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