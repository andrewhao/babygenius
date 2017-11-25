defmodule Babygenius.FetchTimezoneData do
  alias Babygenius.{User, Repo}
  @amazon_device_service Application.get_env(:babygenius, :amazon_device_service)

  def perform(user_id, device_id, consent_token) do
    zip_code = @amazon_device_service.country_and_zip_code(device_id, consent_token)
               |> Map.get("postalCode")

    updated_user = User
                   |> Repo.get!(user_id)
                   |> User.changeset(%{zip_code: zip_code})
                   |> Repo.update!
    {:ok, updated_user}
  end
end

