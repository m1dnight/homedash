defmodule HomeDashWeb.PageController do
  use HomeDashWeb, :controller

  def index(conn, _params) do
    %{gas: g, electricity: e, solar: s, solar_today: std, gas_today: gtd, electricity_today: etd} =
      HomeDash.DataPoints.current()

    render(conn, "index.html",
      electricity: e,
      gas: g,
      solar: s,
      solar_today: std,
      electricity_today: etd,
      gas_today: gtd
    )
  end
end
