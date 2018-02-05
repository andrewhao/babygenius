# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :babygenius, ecto_repos: [Babygenius.Repo]

# Configures the endpoint
config :babygenius, BabygeniusWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BabygeniusWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Babygenius.PubSub, adapter: Phoenix.PubSub.PG2],
  reloadable_compilers: [:gettext, :phoenix, :elixir]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Sentry
config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  included_environments: [:prod],
  environment_name: Mix.env(),
  in_app_module_whitelist: [Babygenius]

config :phoenix, :template_engines, slim: PhoenixSlime.Engine

config :babygenius, :amazon_device_service, BabygeniusWeb.AmazonDeviceService.HttpClient

config :babygenius,
       :fetch_zipcode_from_device_api,
       Babygenius.Locality.FetchZipcodeFromDeviceApi.Live

config :babygenius,
       :zipcode_timezone_service,
       Babygenius.Locality.ZipcodeTimezoneService.HttpClient

config :babygenius, :locality_client, Babygenius.Locality
config :babygenius, :baby_life_client, Babygenius.BabyLife

config :babygenius, :hashids_salt, System.get_env("HASHIDS_SALT")

config :babygenius, :event_publisher, Babygenius.EventPublisher

import_config "scout_apm.exs"

config :babygenius, Babygenius.Repo,
  loggers: [{Ecto.LogEntry, :log, []}, {ScoutApm.Instruments.EctoLogger, :log, []}]

import_config "event_bus.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"