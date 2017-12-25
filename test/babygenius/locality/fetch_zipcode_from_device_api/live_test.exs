defmodule Babygenius.FetchZipcodeFromDeviceApi.LiveTest do
  use Babygenius.DataCase
  import Babygenius.Factory
  import Mox
  alias Babygenius.Locality.FetchZipcodeFromDeviceApi.{Live}
  alias Babygenius.Locality.{Setting}

  setup do
    user = insert(:user)
    {:ok, user: user}
  end

  setup :verify_on_exit!

  describe "perform/3" do
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

      {:ok, result} = Live.perform(user.id, request, fn _, _ -> nil end)
      assert result.zip_code == expected_zip_code
    end
  end

  describe "perform/4" do
    test "queries the Device Address API and stores postal code in setting", %{user: user} do
      expected_zip_code = "94105"

      BabygeniusWeb.AmazonDeviceService.Mock
      |> expect(:country_and_zip_code, fn _device, _consent ->
           %{"postalCode" => expected_zip_code}
         end)

      consent_token = "abcd"
      device_id = "1234"

      {:ok, result} = Live.perform(user.id, device_id, consent_token, fn _, _ -> nil end)
      saved_setting = Repo.all(Setting) |> List.last()
      assert result.zip_code == expected_zip_code
      assert saved_setting.zip_code == expected_zip_code
    end
  end
end