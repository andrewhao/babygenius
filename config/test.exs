use Mix.Config

# We run a server during test for Wallaby integration testing.
config :babygenius, Babygenius.Endpoint,
  http: [port: 4001],
  server: true,
  secret_key_base: "0123456789012345678901234567890123456789012345678901234567890123456789"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :babygenius, Babygenius.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "babygenius_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :babygenius, :sql_sandbox, true

config :babygenius, :amazon_device_service, Babygenius.AmazonDeviceService.Mock
