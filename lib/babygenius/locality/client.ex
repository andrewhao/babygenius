defmodule Babygenius.Locality.Client do
  @moduledoc """
  The Locality context. This manages concerns around a user's location, and their
  associated implications around time zones.
  """

  @behaviour Babygenius.Locality

  import Ecto.Query, warn: true

  alias Babygenius.Repo
  alias Babygenius.Locality.{FetchTimezone, Setting, FetchZipcodeFromDeviceApi}

  @spec process_timezone_for_user(user_id :: String.t(), request :: map()) :: {:ok, pid}
  def process_timezone_for_user(user_id, request) do
    Task.Supervisor.start_child(Babygenius.TaskSupervisor, fn ->
      FetchZipcodeFromDeviceApi.Live.perform(user_id, request)
    end)
  end

  @spec get_timezone_for_user(user_id :: String.t()) :: String.t()
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