use Mix.Config

config :tesla, adapter: Tesla.Mock

config :logger,
  backends: [:console],
  level: :debug
