use Mix.Config

 config :babygenius, Babygenius.Endpoint,
   http: [port: {:system, "PORT"}],
   url: [scheme: "https", host: "babygenius.herokuapp.com", port: 443],
   force_ssl: [rewrite_on: [:x_forwarded_proto]],
   cache_static_manifest: "priv/static/manifest.json",
   secret_key_base: System.get_env("SECRET_KEY_BASE")

 # Configure your database
 config :babygenius, Babygenius.Repo,
   adapter: Ecto.Adapters.Postgres,
   url: System.get_env("DATABASE_URL"),
   pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
   ssl: true
