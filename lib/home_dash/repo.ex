defmodule HomeDash.Repo do
  use Ecto.Repo,
    otp_app: :home_dash,
    adapter: Ecto.Adapters.Postgres
end
