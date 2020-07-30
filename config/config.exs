# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :home_dash,
  ecto_repos: [HomeDash.Repo]

# Configures the endpoint
config :home_dash, HomeDashWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7qbmSECQ8DXTdIogzUyE7cWkfkYDfYlXn4cYuEjW8owJNza3XDsc9Dii6OS3PZh/",
  render_errors: [view: HomeDashWeb.ErrorView, accepts: ~w(html json)],
  # pubsub: [name: HomeDash.PubSub, adapter: Phoenix.PubSub.PG2],
  pubsub_server: HomeDash.PubSub,
  live_view: [signing_salt: "R/RRcygN"]

# Add support for microseconds at the database level
# avoid having to configure it on every migration file
config :home_dash, HomeDash.Repo,
  migration_timestamps: [type: :utc_datetime_usec]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
