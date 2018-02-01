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
            "deviceId" =>
              "amzn1.ask.device.AH6U6HY6STJGU5EWAJ6PKEPWG5W7BTI2LSUV6SS3O3JRYMZ3TEHZO227MOBGD5LESNN7YO7C27BG6LTG3P7NWK7NRC7DRWT5KBVE3BTJB54Q4QOXHVWFF3SS6NPIUF7L3RXLCCSZ45M65GW6GBL7VKZGIPAA",
            "supportedInterfaces" => %{
              "AudioPlayer" => %{},
              "Display" => %{"markupVersion" => "1.0", "templateVersion" => "1.0"}
            }
          },
          "user" => %{
            "permissions" => %{
              "consentToken" =>
                "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjEifQ.eyJhdWQiOiJodHRwczovL2FwaS5hbWF6b25hbGV4YS5jb20iLCJpc3MiOiJBbGV4YVNraWxsS2l0Iiwic3ViIjoiYW16bjEuYXNrLnNraWxsLjExNzUzMzhhLTk5YWYtNDA5My04MGFiLTNlOTkyMmYxODNmNyIsImV4cCI6MTUxNzQzODYwNiwiaWF0IjoxNTE3NDM1MDA2LCJuYmYiOjE1MTc0MzUwMDYsInByaXZhdGVDbGFpbXMiOnsiaXNEZXByZWNhdGVkIjoidHJ1ZSIsImNvbnNlbnRUb2tlbiI6IkF0emF8SXdFQklBcVVLTGh1UG5xVkRlUHVhVWNzbmZsZEI0NDRFb2tkUWtqOWRzTXNCTl9YUnNPc3ZtMzhlek1VS1pUZ0Z6TnFoN09PdlBSQmthdW9XckNybHhVMGUyQXpnYWlaMXM2MTZXRU1TZHdTVEcwNDI3V2FkQ1hTUmQzbmtUdlpZQ2F2WE1TYUJkYTVXa0Npa2JxXzJTbjQyRzZUZDhyY2RScFlzTzVRajNTVTRsS2hOTHZGb2ZsczNVdDB0UjY3OXNQMGZ5RWpMd05MdzhZakMtVmwzZnExZjlkdVpHVVQ0My1rYW5RY0s0eW00Mm5faXFqdWlkQ2xZVmVtSjBaX1Q1Q09JZVg1VWxwRXEteWdnZ1dUSWQ0UzdMQ2doNlZUNWZEMW0tRU5nVW5ocGY0Y09kYk5hQjBaWFRYa3ZwWDhobnlLUXZ3a0FFd1h1RU9BcHNTODF2VThwUXRqS09VYUlvN0RBMXUwdlowNTViTF91MXRMQmdJcnZ4ZWFja2VUZkhJVDNTei1UOTh5ZGh0MG5mdEFwdU0zZkJwNVpySVBLRnlNX1FKa08ySzVCeHRremlZbnFQZTZubVB0QlU3NVRMRkx0TEk0ckxNTmh6MVNKZ1Rnc2txaHlnVmhsNzFaeTZweDVMZGNJUE9RRjBLWHpFa2hHWHFBUXlhdEJ5MTdva2ZkMWxVIiwiZGV2aWNlSWQiOiJhbXpuMS5hc2suZGV2aWNlLkFINlU2SFk2U1RKR1U1RVdBSjZQS0VQV0c1VzdCVEkyTFNVVjZTUzNPM0pSWU1aM1RFSFpPMjI3TU9CR0Q1TEVTTk43WU83QzI3Qkc2TFRHM1A3TldLN05SQzdEUldUNUtCVkUzQlRKQjU0UTRRT1hIVldGRjNTUzZOUElVRjdMM1JYTENDU1o0NU02NUdXNkdCTDdWS1pHSVBBQSIsInVzZXJJZCI6ImFtem4xLmFzay5hY2NvdW50LkFGQlhYRk9CWkNQWDRYN1k0MlNHUFdEV0JCVVRCNTZQQjJOUEQ0V0xZQTdKV1NXTURRVFZNVUk2VUEyS1pUVlQzUUpUNUNSVjdRM0daVlhaUTNWQzU2SUZCRzMyVjVWRE1BRU5YR0laRjdRT1BJNk1SSEszSkpIQVpTNU1XR1IzV0VMUlVFSVpWUkxFUE5WNkhKTFVNSkJTT0VQT1RWRVIyS0hMWFpJWTI3RUFBRVA1UVFTWlNMQUM2UjJERkxSNjVXWE42RTNTNlJINFZGWSJ9fQ.H1j2Q05SYB8YXT08BryAf8Y_3MicimTkn6AqOJp90hFiYZQ7pUXOyv4DEkB55F9lag-8wbtYo_apaP0aL7WEvVD9q-JapVBiiMPgxeTcHNww0TbjT3ea3KGqz771OCUPsV33yC62lNC-b3meslztQYulFGQhswxc5YFYrycVs-u1Ce7pLqPz5GRd_T1HwrbThrNqOLrl5suabdXmw76mdYj9thZMBitxM40tcb5bYLdVwo3OeYWnB6Q-N8tLzrJvHrOBic4pk8eRnHVfI0hnRBV2YMVvBqqiwDpRanM1XATl4gdiLSmY8CVmTXYk7P5Nfva37-_0WTyOiMzfNRKrng"
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
            "consentToken" =>
              "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjEifQ.eyJhdWQiOiJodHRwczovL2FwaS5hbWF6b25hbGV4YS5jb20iLCJpc3MiOiJBbGV4YVNraWxsS2l0Iiwic3ViIjoiYW16bjEuYXNrLnNraWxsLjExNzUzMzhhLTk5YWYtNDA5My04MGFiLTNlOTkyMmYxODNmNyIsImV4cCI6MTUxNzQzODYwNiwiaWF0IjoxNTE3NDM1MDA2LCJuYmYiOjE1MTc0MzUwMDYsInByaXZhdGVDbGFpbXMiOnsiaXNEZXByZWNhdGVkIjoidHJ1ZSIsImNvbnNlbnRUb2tlbiI6IkF0emF8SXdFQklBcVVLTGh1UG5xVkRlUHVhVWNzbmZsZEI0NDRFb2tkUWtqOWRzTXNCTl9YUnNPc3ZtMzhlek1VS1pUZ0Z6TnFoN09PdlBSQmthdW9XckNybHhVMGUyQXpnYWlaMXM2MTZXRU1TZHdTVEcwNDI3V2FkQ1hTUmQzbmtUdlpZQ2F2WE1TYUJkYTVXa0Npa2JxXzJTbjQyRzZUZDhyY2RScFlzTzVRajNTVTRsS2hOTHZGb2ZsczNVdDB0UjY3OXNQMGZ5RWpMd05MdzhZakMtVmwzZnExZjlkdVpHVVQ0My1rYW5RY0s0eW00Mm5faXFqdWlkQ2xZVmVtSjBaX1Q1Q09JZVg1VWxwRXEteWdnZ1dUSWQ0UzdMQ2doNlZUNWZEMW0tRU5nVW5ocGY0Y09kYk5hQjBaWFRYa3ZwWDhobnlLUXZ3a0FFd1h1RU9BcHNTODF2VThwUXRqS09VYUlvN0RBMXUwdlowNTViTF91MXRMQmdJcnZ4ZWFja2VUZkhJVDNTei1UOTh5ZGh0MG5mdEFwdU0zZkJwNVpySVBLRnlNX1FKa08ySzVCeHRremlZbnFQZTZubVB0QlU3NVRMRkx0TEk0ckxNTmh6MVNKZ1Rnc2txaHlnVmhsNzFaeTZweDVMZGNJUE9RRjBLWHpFa2hHWHFBUXlhdEJ5MTdva2ZkMWxVIiwiZGV2aWNlSWQiOiJhbXpuMS5hc2suZGV2aWNlLkFINlU2SFk2U1RKR1U1RVdBSjZQS0VQV0c1VzdCVEkyTFNVVjZTUzNPM0pSWU1aM1RFSFpPMjI3TU9CR0Q1TEVTTk43WU83QzI3Qkc2TFRHM1A3TldLN05SQzdEUldUNUtCVkUzQlRKQjU0UTRRT1hIVldGRjNTUzZOUElVRjdMM1JYTENDU1o0NU02NUdXNkdCTDdWS1pHSVBBQSIsInVzZXJJZCI6ImFtem4xLmFzay5hY2NvdW50LkFGQlhYRk9CWkNQWDRYN1k0MlNHUFdEV0JCVVRCNTZQQjJOUEQ0V0xZQTdKV1NXTURRVFZNVUk2VUEyS1pUVlQzUUpUNUNSVjdRM0daVlhaUTNWQzU2SUZCRzMyVjVWRE1BRU5YR0laRjdRT1BJNk1SSEszSkpIQVpTNU1XR1IzV0VMUlVFSVpWUkxFUE5WNkhKTFVNSkJTT0VQT1RWRVIyS0hMWFpJWTI3RUFBRVA1UVFTWlNMQUM2UjJERkxSNjVXWE42RTNTNlJINFZGWSJ9fQ.H1j2Q05SYB8YXT08BryAf8Y_3M"
          },
          "userId" =>
            "amzn1.ask.account.AFBXXFOBZCPX4X7Y42SGPWDWBBUTB56PB2NPD4WLYA7JWSWMDQTVMUI6UA2KZTVT3QJT5CRV7Q3GZVXZQ3VC56IFBG32V5VDMAENXGIZF7QOPI6MRHK3JJHAZS5MWGR3WELRUEIZVRLEPNV6HJLUMJBSOEPOTVER2KHLXZIY27EAAEP5QQSZSLAC6R2DFLR65WXN6E3S6RH4VFY"
        }
      }
    }
    |> Morphix.atomorphiform!()
  end
end
