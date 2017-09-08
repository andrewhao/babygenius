defmodule Babygenius.UserControllerTest do
  use Babygenius.ConnCase, async: true
  use Babygenius.Web, :model

  describe "intent_request/3" do
    setup do
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
  "context": {
    "AudioPlayer": {
      "playerActivity": "IDLE"
    },
    "System": {
      "application": {
        "applicationId": "amzn1.ask.skill.1175338a-99af-4093-80ab-3e9922f183f7"
      },
      "user": {
        "userId": "amzn1.ask.account.AFBXXFOBZCPX4X7Y42SGPWDWBBUTB56PB2NPD4WLYA7JWSWMDQTVMUI6UA2KZTVT3QJT5CRV7Q3GZVXZQ3VC56IFBG32V5VDMAENXGIZF7QOPI6MRHK3JJHAZS5MWGR3WELRUEIZVRLEPNV6HJLUMJBSOEPOTVER2KHLXZIY27EAAEP5QQSZSLAC6R2DFLR65WXN6E3S6RH4VFY"
      },
      "device": {
        "supportedInterfaces": {}
      }
    }
  },
  "version": "1.0"
}
"""

      response = build_conn()
			|> put_req_header("accept", "application/json")
			|> put_req_header("content-type", "application/json")
      |> post(alexa_path(build_conn(), :command), json)

      {:ok, response: response}
    end

    test "responds with shouldEndSession true", context do
      response = context[:response] |> json_response(200)
      assert response["response"]["shouldEndSession"] == true
    end

    test "adds a DiaperChange record into the DB", context do
      old_count = Repo.aggregate(DiaperChange, :count, :id)
      response = context[:response] |> json_response(200)
      new_count = Repo.aggregate(DiaperChange, :count, :id)
      assert old_count == new_count - 1
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
      response = build_conn()
			|> put_req_header("accept", "application/json")
			|> put_req_header("content-type", "application/json")
      |> post(alexa_path(build_conn(), :command), json)
      |> json_response(200)

      assert response["response"]["outputSpeech"]["text"] == "Welcome to Babygenius. What would you like to log today? You can log a feeding, or a diaper change. For help, say Help."
      assert response["response"]["shouldEndSession"] == false
    end
  end
end
