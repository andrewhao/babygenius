defmodule BabygeniusWeb.FetchTimezoneData do
  alias BabygeniusWeb.{User}
  alias Babygenius.{Repo}
  @amazon_device_service Application.get_env(:babygenius, :amazon_device_service)

  @spec perform(user_id :: String.t(), request :: map()) :: {:ok, %User{}}
  def perform(user_id, request) do
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

    perform(user_id, device_id, consent_token)
  end

  @spec perform(user_id :: String.t(), device_id :: String.t(), consent_token: String.t()) ::
          {:ok, %User{}}
  def perform(user_id, device_id, consent_token) do
    zip_code =
      @amazon_device_service.country_and_zip_code(device_id, consent_token)
      |> Map.get("postalCode")

    updated_user =
      User
      |> Repo.get!(user_id)
      |> User.changeset(%{zip_code: zip_code, consent_token: consent_token, device_id: device_id})
      |> Repo.update!()

    {:ok, updated_user}
  end
end