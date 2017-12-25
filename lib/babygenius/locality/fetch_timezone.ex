defmodule Babygenius.Locality.FetchTimezone do
  @moduledoc """
  Task that checks the timezone for user in zip, and updates user setting
  if the timezone is valid.
  """
  alias Babygenius.{Repo, Locality}
  alias Locality.Setting

  @zipcode_timezone_service Application.get_env(:babygenius, :zipcode_timezone_service)

  @spec run(String.t(), %Setting{}) :: %Setting{}
  def run(zipcode, setting) do
    @zipcode_timezone_service.fetch_zipcode(zipcode)
    |> Map.get(:timezone)
    |> IO.inspect(label: "Timezone fetched is")
    |> setting_changeset(setting)
    |> Repo.update!()
  end

  defp setting_changeset(timezone, setting) do
    Setting.changeset(setting, %{timezone_identifier: timezone})
  end
end