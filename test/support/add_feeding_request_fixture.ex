defmodule Babygenius.AddFeedingRequestFixture do
  def amazon_id do
    "amzn1.ask.account.AFBXXFOBZCPX4X7Y42SGPWDWBBUTB56PB2NPD4WLYA7JWSWMDQTVMUI6UA2KZTVT3QJT5CRV7Q3GZVXZQ3VC56IFBG32V5VDMAENXGIZF7QOPI6MRHK3JJHAZS5MWGR3WELRUEIZVRLEPNV6HJLUMJBSOEPOTVER2KHLXZIY27EAAEP5QQSZSLAC6R2DFLR65WXN6E3S6RH4VFY"
  end

  def as_json do
    Poison.encode!(as_map())
  end

  def as_map() do
    %{
      "context" => %{
        "Display" => %{},
        "System" => %{
          "apiAccessToken" =>
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjEifQ.eyJhdWQiOiJodHRwczovL2FwaS5hbWF6b25hbGV4YS5jb20iLCJpc3MiOiJBbGV4YVNraWxsS2l0Iiwic3ViIjoiYW16bjEuYXNrLnNraWxsLjExNzUzMzhhLTk5YWYtNDA5My04MGFiLTNlOTkyMmYxODNmNyIsImV4cCI6MTUxNzQzODYwNiwiaWF0IjoxNTE3NDM1MDA2LCJuYmYiOjE1MTc0MzUwMDYsInByaXZhdGVDbGFpbXMiOnsiY29uc2VudFRva2VuIjoiQXR6YXxJd0VCSUFxVUtMaHVQbnFWRGVQdWFVY3NuZmxkQjQ0NEVva2RRa2o5ZHNNc0JOX1hSc09zdm0zOGV6TVVLWlRnRnpOcWg3T092UFJCa2F1b1dyQ3JseFUwZTJBemdhaVoxczYxNldFTVNkd1NURzA0MjdXYWRDWFNSZDNua1R2WllDYXZYTVNhQmRhNVdrQ2lrYnFfMlNuNDJHNlRkOHJjZFJwWXNPNVFqM1NVNGxLaE5MdkZvZmxzM1V0MHRSNjc5c1AwZnlFakx3Tkx3OFlqQy1WbDNmcTFmOWR1WkdVVDQzLWthblFjSzR5bTQybl9pcWp1aWRDbFlWZW1KMFpfVDVDT0llWDVVbHBFcS15Z2dnV1RJZDRTN0xDZ2g2VlQ1ZkQxbS1FTmdVbmhwZjRjT2RiTmFCMFpYVFhrdnBYOGhueUtRdndrQUV3WHVFT0Fwc1M4MXZVOHBRdGpLT1VhSW83REExdTB2WjA1NWJMX3UxdExCZ0lydnhlYWNrZVRmSElUM1N6LVQ5OHlkaHQwbmZ0QXB1TTNmQnA1WnJJUEtGeU1fUUprTzJLNUJ4dGt6aVlucVBlNm5tUHRCVTc1VExGTHRMSTRyTE1OaHoxU0pnVGdza3FoeWdWaGw3MVp5NnB4NUxkY0lQT1FGMEtYekVraEdYcUFReWF0QnkxN29rZmQxbFUiLCJkZXZpY2VJZCI6ImFtem4xLmFzay5kZXZpY2UuQUg2VTZIWTZTVEpHVTVFV0FKNlBLRVBXRzVXN0JUSTJMU1VWNlNTM08zSlJZTVozVEVIWk8yMjdNT0JHRDVMRVNOTjdZTzdDMjdCRzZMVEczUDdOV0s3TlJDN0RSV1Q1S0JWRTNCVEpCNTRRNFFPWEhWV0ZGM1NTNk5QSVVGN0wzUlhMQ0NTWjQ1TTY1R1c2R0JMN1ZLWkdJUEFBIiwidXNlcklkIjoiYW16bjEuYXNrLmFjY291bnQuQUZCWFhGT0JaQ1BYNFg3WTQyU0dQV0RXQkJVVEI1NlBCMk5QRDRXTFlBN0pXU1dNRFFUVk1VSTZVQTJLWlRWVDNRSlQ1Q1JWN1EzR1pWWFpRM1ZDNTZJRkJHMzJWNVZETUFFTlhHSVpGN1FPUEk2TVJISzNKSkhBWlM1TVdHUjNXRUxSVUVJWlZSTEVQTlY2SEpMVU1KQlNPRVBPVFZFUjJLSExYWklZMjdFQUFFUDVRUVNaU0xBQzZSMkRGTFI2NVdYTjZFM1M2Ukg0VkZZIn19.Sjsc2SxUGzKSQ7GSdjNaxHSnOCbb63oJy3X5lpo5nMfIY47TYHCc-aOViVWc7_oqzsSZDsRTC1r8oNqCF5wD-FS5rcGc2H72s_Na3nsSOy0jMBzIYtYn8NYcqsIfnh6XuVt32iQy0DV3ywfO2E4GMhUfiX9mCjd56UrnnPHeyZ--B6DIHynCBSsBkRKiV4fMqpxMH31pPTTbBqlmdoDwlrcSsjZADY7NRBGyDHDYw0EJY-pqnEaEXwQeUPZRwES5Jzx6g3La5HitxdkQvmLN-eidLoYQVLayd1TkQnJ27fNIj80tmRDBg5lWJph6ZA8fHnqafBhs8FmX3QNSheG9Zw",
          "apiEndpoint" => "https://api.amazonalexa.com",
          "application" => %{
            "applicationId" => "amzn1.ask.skill.1175338a-99af-4093-80ab-3e9922f183f7"
          },
          "device" => %{
            "deviceId" => "amzn1.ask.device.AH6U6HY6S",
            "supportedInterfaces" => %{
              "AudioPlayer" => %{},
              "Display" => %{"markupVersion" => "1.0", "templateVersion" => "1.0"}
            }
          },
          "user" => %{
            "permissions" => %{
              "consentToken" => "eyJ0eXA"
            },
            "userId" =>
              "amzn1.ask.account.AFBXXFOBZCPX4X7Y42SGPWDWBBUTB56PB2NPD4WLYA7JWSWMDQTVMUI6UA2KZTVT3QJT5CRV7Q3GZVXZQ3VC56IFBG32V5VDMAENXGIZF7QOPI6MRHK3JJHAZS5MWGR3WELRUEIZVRLEPNV6HJLUMJBSOEPOTVER2KHLXZIY27EAAEP5QQSZSLAC6R2DFLR65WXN6E3S6RH4VFY"
          }
        }
      },
      "request" => %{
        "dialogState" => "STARTED",
        "intent" => %{
          "confirmationStatus" => "NONE",
          "name" => "AddFeeding",
          "slots" => %{
            "amount" => %{"confirmationStatus" => "NONE", "name" => "amount"},
            "feedDate" => %{
              "confirmationStatus" => "NONE",
              "name" => "feedDate",
              "value" => "2018-01-27"
            },
            "feedName" => %{
              "confirmationStatus" => "NONE",
              "name" => "feedName",
              "resolutions" => %{
                "resolutionsPerAuthority" => [
                  %{
                    "authority" =>
                      "amzn1.er-authority.echo-sdk.amzn1.ask.skill.1175338a-99af-4093-80ab-3e9922f183f7.FeedName",
                    "status" => %{"code" => "ER_SUCCESS_MATCH"},
                    "values" => [
                      %{
                        "value" => %{"id" => "b068931cc450442b63f5b3d276ea4297", "name" => "name"}
                      }
                    ]
                  }
                ]
              },
              "value" => "feeding"
            },
            "feedTime" => %{"confirmationStatus" => "NONE", "name" => "feedTime"},
            "logAction" => %{
              "confirmationStatus" => "NONE",
              "name" => "logAction",
              "resolutions" => %{
                "resolutionsPerAuthority" => [
                  %{
                    "authority" =>
                      "amzn1.er-authority.echo-sdk.amzn1.ask.skill.1175338a-99af-4093-80ab-3e9922f183f7.LogAction",
                    "status" => %{"code" => "ER_SUCCESS_MATCH"},
                    "values" => [
                      %{"value" => %{"id" => "dc1d71bbb5c4d2a5e936db79ef10c19f", "name" => "log"}}
                    ]
                  }
                ]
              },
              "value" => "log"
            },
            "volumeUnit" => %{"confirmationStatus" => "NONE", "name" => "volumeUnit"}
          }
        },
        "locale" => "en-US",
        "requestId" => "amzn1.echo-api.request.6656a411-7c51-4fa0-9d72-69b1f9dc4ff4",
        "timestamp" => "2018-01-31T21:43:26Z",
        "type" => "IntentRequest"
      },
      "session" => %{
        "application" => %{
          "applicationId" => "amzn1.ask.skill.1175338a-99af-4093-80ab-3e9922f183f7"
        },
        "new" => true,
        "sessionId" => "amzn1.echo-api.session.019bd6f2-7c93-4d7b-8153-4cbd0dcdce66",
        "user" => %{
          "permissions" => %{
            "consentToken" => "eyJ0eXA"
          },
          "userId" =>
            "amzn1.ask.account.AFBXXFOBZCPX4X7Y42SGPWDWBBUTB56PB2NPD4WLYA7JWSWMDQTVMUI6UA2KZTVT3QJT5CRV7Q3GZVXZQ3VC56IFBG32V5VDMAENXGIZF7QOPI6MRHK3JJHAZS5MWGR3WELRUEIZVRLEPNV6HJLUMJBSOEPOTVER2KHLXZIY27EAAEP5QQSZSLAC6R2DFLR65WXN6E3S6RH4VFY"
        }
      }
    }
    |> Morphix.atomorphiform!()
  end
end