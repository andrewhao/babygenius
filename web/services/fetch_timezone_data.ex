defmodule Babygenius.FetchTimezoneData do
  alias Babygenius.{User, Repo}
  @amazon_device_service Application.get_env(:babygenius, :amazon_device_service)

  def perform(user_id, device_id, consent_token) do
    url = "https://api.amazonalexa.com/v1/devices/#{device_id}/settings/address/countryAndPostalCode"
    headers = [{"Authorization", "Bearer #{consent_token}"}, {"Accept", "application/json"}]
    zip_code = @amazon_device_service.country_and_zip_code(device_id, consent_token)
               |> Apex.ap
               |> Map.get("postalCode")

    updated_user = User
                   |> Repo.get!(user_id)
                   |> User.changeset(%{zip_code: zip_code})
                   |> Repo.update!
                   |> Apex.ap
    {:ok, updated_user}
  end
end

