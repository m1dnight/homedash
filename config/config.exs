# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :homedash,
  ecto_repos: [Homedash.Repo]

# Configures the endpoint
config :homedash, HomedashWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "C08kNkqQ/I598+brIB5MEJtI7ke/6tgFI4+ej1GiF14sWRoKmWyxBsvJO7sL2s57",
  render_errors: [view: HomedashWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Homedash.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "C08kNkqQ/I598+brIB5MEJtI7ke/6tgFI4+ej1GiF14sWRoKmWyxBsvJO7sL2s57"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# tzdata
# config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
# config :tzdata, :autoupdate, :disabled
# config :tzdata, :data_dir, "/etc/elixir_tzdata_data"

# tz
config :elixir, :time_zone_database, Tz.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
