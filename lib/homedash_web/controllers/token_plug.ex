defmodule HomedashWeb.Token do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(%Plug.Conn{request_path: path} = conn, opts) do
    if path in opts[:exclude] do
      conn
    else
      token = Map.get(conn.body_params, "token", nil)

      if valid_token?(token) do
        conn
      else
        conn
        |> send_resp(
          500,
          "JSON API requires a token. Either token is invalid, or token is missing."
        )
        |> halt()
      end
    end
  end

  # Checks if the passed token matches the one in the config.
  defp valid_token?(token) do
    global_token = Application.fetch_env!(:homedash, :api_token)

    case token do
      nil ->
        false

      token ->
        token == global_token
    end
  end
end
