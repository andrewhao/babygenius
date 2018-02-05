use Mix.Config

config :event_bus,
  topics: [
    :"identity.user.created",
    :"locality.zip_code.fetched",
    :"locality.time_zone.fetched",
    :"baby_life.diaper_change.created",
    :"baby_life.feeding.created"
  ]

config :event_bus_logger,
  # is it enabled
  enabled: {:system, "EB_LOGGER_ENABLED", "true"},
  # logging level
  level: {:system, "EB_LOGGER_LEVEL", :info},
  # can be seperated by ';'
  topics: {:system, "EB_LOGGER_TOPICS", ".*"},
  # enable light logging
  light_logging: {:system, "EB_LOGGER_LIGHT", "false"}
