defmodule Babygenius.Locality.FetchZipcodeFromDeviceApi.Live do
  alias Babygenius.{Repo, Locality}
  alias Locality.Setting

  @behaviour Babygenius.Locality.FetchZipcodeFromDeviceApi

  @identity_client Application.get_env(:babygenius, :identity_client)
  @amazon_device_service Application.get_env(:babygenius, :amazon_device_service)

  @impl true
  def perform(
        user_id,
        zipcode_fn \\ &Locality.fetch_timezone_by_zipcode_for_setting/2
      ) do
    user = @identity_client.get_user_by_id(user_id)

    zip_code =
      @amazon_device_service.country_and_zip_code(user.device_id, user.consent_token)
      |> Map.get("postalCode")

    updated_setting =
      case Repo.get_by(Setting, user_id: to_string(user_id)) do
        nil -> %Setting{user_id: to_string(user_id)}
        setting -> setting
      end
      |> Setting.changeset(%{zip_code: zip_code})
      |> Repo.insert_or_update!()

    zipcode_fn.(zip_code, updated_setting)

    {:ok, updated_setting}
  end
end