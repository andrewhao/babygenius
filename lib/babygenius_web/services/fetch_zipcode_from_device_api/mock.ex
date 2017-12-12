defmodule BabygeniusWeb.FetchZipcodeFromDeviceApi.Mock do
  alias BabygeniusWeb.{User}
  alias Babygenius.{Repo, Locality}

  @behaviour BabygeniusWeb.FetchZipcodeFromDeviceApi

  @spec perform(user_id :: String.t(), request :: map(), zipcode_fn :: fun()) :: {:ok, %User{}}
  def perform(user_id, request, zipcode_fn \\ &Locality.fetch_timezone_by_zipcode_for_user/2) do
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
        ) :: {:ok, %User{}}
  def perform(user_id, _device_id, _consent_token, _zipcode_fn) do
    updated_user =
      User
      |> Repo.get!(user_id)
      |> Map.put(:zip_code, "94110")

    {:ok, updated_user}
  end
end