defmodule Babygenius.AlexaControllerTest do
  use BabygeniusWeb.ConnCase, async: true
  use BabygeniusWeb, :model
  use Timex

  import Mox

  alias BabygeniusWeb.{User, DiaperChange}

  describe "intent_request/3" do
    setup do
      zip_code = "94110"

      BabygeniusWeb.AmazonDeviceService.Mock
      |> expect(:country_and_zip_code, fn _device, _consent -> %{"postalCode" => zip_code} end)

      json = """
      {
        "session": {
          "new": false,
          "sessionId": "SessionId.adb3cd0a-f4fd-46be-acfb-d490b3a9b2d6",
          "application": {
            "applicationId": "amzn1.ask.skill.1175338a-99af-4093-80ab-3e9922f183f7"
          },
          "attributes": {},
          "user": {
            "userId": "amzn1.ask.account.AFBXXFOBZCPX4X7Y42SGPWDWBBUTB56PB2NPD4WLYA7JWSWMDQTVMUI6UA2KZTVT3QJT5CRV7Q3GZVXZQ3VC56IFBG32V5VDMAENXGIZF7QOPI6MRHK3JJHAZS5MWGR3WELRUEIZVRLEPNV6HJLUMJBSOEPOTVER2KHLXZIY27EAAEP5QQSZSLAC6R2DFLR65WXN6E3S6RH4VFY"
          }
        },
        "request": {
          "type": "IntentRequest",
          "requestId": "EdwRequestId.f7639b89-fa9b-45cc-8a1b-75da66ee3c8e",
          "intent": {
            "name": "AddDiaperChange",
            "slots": {
              "diaperChangeDate": {
                "name": "diaperChangeDate",
                "value": "2017-09-08"
              },
              "diaperChangeTime": {
                "name": "diaperChangeTime",
                "value": "03:00"
              },
              "logAction": {
                "name": "logAction",
                "value": "log"
              },
              "diaperType": {
                "name": "diaperType",
                "value": "wet"
              }
            }
          },
          "locale": "en-US",
          "timestamp": "2017-09-08T01:15:02Z"
        },
        "context": {"AudioPlayer": {"playerActivity": "IDLE"},
          "System": {
            "apiAccessToken": "eyJ0e",
            "apiEndpoint": "https://api.amazonalexa.com",
            "application": {"applicationId": "amzn1.ask.skill.1175338a-99af-4093-80ab-3e9922f183f7"},
            "device": {
              "deviceId": "amzn1.ask.device.AH6U6HY6STJGU5EWAJ6PKEPWG5W6QCOQCJZ7JCL6O5R7TQVXOMVM6YDYK6PXXBD6PEGO3NXGPICDRERSICU65VRZZAMAWBETLA6B4O2RV23K6G6EMMUAWLSIV3ONZXNSRVU35GMGJMFWYABJWYLOQM57UMIQ",
              "supportedInterfaces": {"AudioPlayer": {}}
            },
            "user": {
              "permissions": {
                "consentToken": "eyJ0eX"
              },
              "userId": "amzn1.ask.account.AFBXXFOBZCPX4X7Y42SGPWDWBBUTB56PB2NPD4WLYA7JWSWMDQTVMUI6UA2KZTVT3QJT5CRV7Q3GZVXZQ3VC56IFBG32V5VDMAENXGIZF7QOPI6MRHK3JJHAZS5MWGR3WELRUEIZVRLEPNV6HJLUMJBSOEPOTVER2KHLXZIY27EAAEP5QQSZSLAC6R2DFLR65WXN6E3S6RH4VFY"}
          }
        },
        "version": "1.0"
      }
      """

      request =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("content-type", "application/json")

      {:ok, request: request, json: json, zip_code: zip_code}
    end

    test "responds with shouldEndSession true", context do
      response =
        context[:request]
        |> post(alexa_path(build_conn(), :command), context[:json])
        |> json_response(200)

      assert response["response"]["shouldEndSession"] == true
    end

    test "adds a DiaperChange record into the DB", context do
      old_count = Repo.aggregate(from(dc in "diaper_changes"), :count, :id)

      context[:request]
      |> post(alexa_path(build_conn(), :command), context[:json])
      |> json_response(200)

      new_count = Repo.aggregate(from(dc in "diaper_changes"), :count, :id)
      assert old_count == new_count - 1
    end

    test "it creates a new user if one does not already exist", context do
      old_count = Repo.aggregate(from(dc in "users"), :count, :id)

      context[:request]
      |> post(alexa_path(build_conn(), :command), context[:json])
      |> json_response(200)

      new_count = Repo.aggregate(from(dc in "users"), :count, :id)
      assert old_count == new_count - 1
    end

    test "it does not create a new user if one already exists", context do
      %User{
        amazon_id:
          "amzn1.ask.account.AFBXXFOBZCPX4X7Y42SGPWDWBBUTB56PB2NPD4WLYA7JWSWMDQTVMUI6UA2KZTVT3QJT5CRV7Q3GZVXZQ3VC56IFBG32V5VDMAENXGIZF7QOPI6MRHK3JJHAZS5MWGR3WELRUEIZVRLEPNV6HJLUMJBSOEPOTVER2KHLXZIY27EAAEP5QQSZSLAC6R2DFLR65WXN6E3S6RH4VFY"
      }
      |> Repo.insert!()

      old_count = Repo.aggregate(from(dc in "users"), :count, :id)

      context[:request]
      |> post(alexa_path(build_conn(), :command), context[:json])
      |> json_response(200)

      new_count = Repo.aggregate(from(dc in "users"), :count, :id)
      assert old_count == new_count
    end

    test "logs a DiaperChange with the right type", context do
      _response =
        context[:request]
        |> post(alexa_path(build_conn(), :command), context[:json])
        |> json_response(200)

      type = DiaperChange |> last |> Repo.one() |> Map.fetch!(:type)

      assert type == "wet"
    end

    test "it responds with confirmation text", context do
      response =
        context[:request]
        |> post(alexa_path(build_conn(), :command), context[:json])
        |> json_response(200)

      DiaperChange |> last |> Repo.one() |> Map.fetch!(:occurred_at)

      assert get_in(response, ["response", "outputSpeech", "text"]) ==
               "A wet diaper change was logged September 8th at 3:00 AM"
    end

    @tag :skip
    test "it looks up zip code and stores in the DB", %{
      request: request,
      json: json,
      zip_code: zip_code
    } do
      response =
        request
        |> post(alexa_path(build_conn(), :command), json)
        |> json_response(200)

      user = User |> last |> Repo.one()
      assert user.zip_code == zip_code
    end

    @tag :skip
    test "it looks up time zone and stores in the DB", %{
      request: request,
      json: json,
      zip_code: zip_code
    } do
      response =
        request
        |> post(alexa_path(build_conn(), :command), json)
        |> json_response(200)

      user = User |> last |> Repo.one()
      assert user.timezone_identifier == "America/Los_Angeles"
    end
  end

  describe "launch_request/2" do
    test "responds with initial launch text" do
      json = """
      {
        "session": {
          "sessionId": "SessionId.80ef8951-172e-4f02-ace8-a7ec847e2d9f",
          "application": {
            "applicationId": "amzn1.echo-sdk-ams.app.05dcb1a4-cb45-46c5-a30e-bb3033a0770a"
          },
          "attributes": {},
          "user": {
            "userId": "amzn1.ask.account.AFP3ZWPOS2BGJR7OWJZ3DHPKMOMNWY4AY66FUR7ILBWANIHQN73QH3G5PC2FJVGDIDA7MY54GGNRGM4SVPKTT3K53SLI232MEFI77TZN7W6LISNFZTTFDSPCLX6OB4ISJDVJB6QZO3XC74US6CH5DQXYCVOODNTUFNI5JNSUWSBDVMWB7JXPVX43P4EUIMHTPZHNRHZDUDENZVI"
          },
          "new": false
        },
        "request": {
          "type": "LaunchRequest",
          "requestId": "EdwRequestId.27142539-8af4-430c-8f22-411cfab269bd",
          "timestamp": "2016-07-07T00:45:08Z"
        },
        "version": "1.0"
      }
      """

      response =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("content-type", "application/json")
        |> post(alexa_path(build_conn(), :command), json)
        |> json_response(200)

      assert response["response"]["outputSpeech"]["text"] ==
               "Welcome to Babygenius. What would you like to log today? You can log a feeding, or a diaper change. For help, say Help."

      assert response["response"]["shouldEndSession"] == false
    end
  end
end