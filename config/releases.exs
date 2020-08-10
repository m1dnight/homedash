import Config

################################################################################
# Database #####################################################################
################################################################################

db_host =
  System.get_env("DATABASE_HOST") ||
    raise """
    environment variable DATABASE_HOST is missing.
    """

db_database = System.get_env("DATABASE_DB") || "postgres"
db_username = System.get_env("DATABASE_USER") || "postgres"
db_password = System.get_env("DATABASE_PASSWORD") || "postgres"
db_url = "ecto://#{db_username}:#{db_password}@#{db_host}/#{db_database}"

config :home_dash, HomeDash.Repo,
  url: db_url,
  pool_size: 20

################################################################################
# Secrets ######################################################################
################################################################################

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

port = String.to_integer(System.get_env("PORT", "1234"))

live_view_salt =
  System.get_env("LIVE_VIEW_SALT") ||
    raise """
    environment variable LIVE_VIEW_SALT is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :home_dash, HomeDashWeb.Endpoint,
  secret_key_base: secret_key_base,
  url: [host: System.get_env("APP_HOST")],
  http: [
    port: port,
    transport_options: [socket_opts: [:inet6]]
  ],
  live_view: [signing_salt: live_view_salt],
  server: true

################################################################################
# Token for API ################################################################
################################################################################

token =
  System.get_env("API_TOKEN") ||
    raise """
    environment variable API_TOKEN is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :home_dash, api_token: token
