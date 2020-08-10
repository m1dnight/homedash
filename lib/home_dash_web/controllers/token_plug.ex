defmodule HomeDashWeb.Token do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    token = Map.get(conn.body_params, "token", nil)

    if valid_token?(token) do
      conn
    else
      conn
      |> send_resp(500, "JSON API requires a token. Either token is invalid, or token is missing.")
      |> halt()
    end
  end

  # Checks if the passed token matches the one in the config.
  defp valid_token?(token) do
    global_token = Application.fetch_env!(:home_dash, :api_token)

    case token do
      nil ->
        false

      token ->
        token == global_token
    end
  end
end
