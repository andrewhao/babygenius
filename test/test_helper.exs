ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Babygenius.Repo, :manual)

# Auto-skip tests with @tag :skip
ExUnit.configure(exclude: [skip: true])

# Wallaby
{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, BabygeniusWeb.Endpoint.url())

# ExMachina
{:ok, _} = Application.ensure_all_started(:ex_machina)

# Mox
Mox.defmock(BabygeniusWeb.AmazonDeviceService.Mock, for: BabygeniusWeb.AmazonDeviceService)

Mox.defmock(
  Babygenius.Locality.FetchZipcodeFromDeviceApi.Mock,
  for: Babygenius.Locality.FetchZipcodeFromDeviceApi
)

Mox.defmock(
  Babygenius.Locality.ZipcodeTimezoneService.Mock,
  for: Babygenius.Locality.ZipcodeTimezoneService
)

{:ok, _} = Application.ensure_all_started(:mox)