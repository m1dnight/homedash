defmodule HomeDashWeb.PageController do
  use HomeDashWeb, :controller

  def index(conn, _params) do
    %{
      gas: g,
      electricity: e,
      solar: s,
      solar_today: std,
      gas_today: gtd,
      electricity_today: etd,
      electricity_totals: ets,
      gas_totals: gts,
      solar_totals: sts
    } = HomeDash.DataPoints.current()

    render(conn, "index.html",
      electricity: e,
      gas: g,
      solar: s,
      solar_today: std,
      electricity_today: etd,
      gas_today: gtd,
      electricity_totals: ets,
      gas_totals: gts,
      solar_totals: sts
    )
  end
end
