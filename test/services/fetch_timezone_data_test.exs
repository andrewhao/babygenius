defmodule Babygenius.FetchTimezoneDataTest do
  use Babygenius.ModelCase
  import Babygenius.Factory
  import Mox
  alias BabygeniusWeb.{FetchTimezoneData}

  setup do
    user = insert(:user)
    {:ok, user: user}
  end

  setup :verify_on_exit!

  describe "perform/2" do
    test "queries the Device Address API with bare request map", %{user: user} do
      consent_token = "ConsentTokenValue"
      device_id = "DeviceId"

      request = %{
        context: %{
          AudioPlayer: %{playerActivity: "IDLE"},
          System: %{
            apiAccessToken: "eyJ0e",
            apiEndpoint: "https://api.amazonalexa.com",
            application: %{applicationId: "amzn1.ask.skill.1175338a-99af-4093-80ab-3e9922f183f7"},
            device: %{
              deviceId: device_id,
              supportedInterfaces: %{AudioPlayer: %{}}
            },
            user: %{
              permissions: %{
                consentToken: consent_token
              },
              userId: "UserIdValue"
            }
          }
        }
      }

      expected_zip_code = "94105"

      BabygeniusWeb.AmazonDeviceService.Mock
      |> expect(:country_and_zip_code, fn _device, _consent ->
           %{"postalCode" => expected_zip_code}
         end)

      {:ok, result} = FetchTimezoneData.perform(user.id, request)
      assert result.id == user.id
      assert result.zip_code == expected_zip_code
      assert result.consent_token == consent_token
      assert result.device_id == device_id
    end
  end

  describe "perform/3" do
    test "queries the Device Address API and stores postal code in user", %{user: user} do
      expected_zip_code = "94105"

      BabygeniusWeb.AmazonDeviceService.Mock
      |> expect(:country_and_zip_code, fn _device, _consent ->
           %{"postalCode" => expected_zip_code}
         end)

      consent_token = "abcd"
      device_id = "1234"

      {:ok, result} = FetchTimezoneData.perform(user.id, device_id, consent_token)
      assert result.id == user.id
      assert result.zip_code == expected_zip_code
      assert result.consent_token == consent_token
      assert result.device_id == device_id
    end
  end
end