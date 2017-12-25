defmodule Babygenius.Locality.FetchZipcodeFromDeviceApi.Live do
  alias Babygenius.{Repo, Locality}
  alias Locality.Setting

  @behaviour Babygenius.Locality.FetchZipcodeFromDeviceApi

  @amazon_device_service Application.get_env(:babygenius, :amazon_device_service)

  @spec perform(user_id :: String.t(), request :: map(), zipcode_fn :: fun()) :: {:ok, %Setting{}}
  def perform(user_id, request, zipcode_fn \\ &Locality.fetch_timezone_by_zipcode_for_setting/2) do
    %{
      context: %{
        System: %{
          device: %{deviceId: device_id},
          user: %{
            permissions: %{
              consentToken: consent_token
            }
          }
        }
      }
    } = request

    perform(user_id, device_id, consent_token, zipcode_fn)
  end

  @spec perform(
          user_id :: String.t(),
          device_id :: String.t(),
          consent_token :: String.t(),
          zipcode_fn :: fun()
        ) :: {:ok, %Setting{}}
  def perform(user_id, device_id, consent_token, zipcode_fn) do
    zip_code =
      @amazon_device_service.country_and_zip_code(device_id, consent_token)
      |> Map.get("postalCode")

    updated_setting =
      %Setting{user_id: user_id |> to_string()}
      |> Setting.changeset(%{zip_code: zip_code})
      |> Repo.insert_or_update!()

    zipcode_fn.(zip_code, updated_setting)

    {:ok, updated_setting}
  end
end