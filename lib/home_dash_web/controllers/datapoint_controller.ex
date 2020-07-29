defmodule HomeDashWeb.DataPointController do
  use HomeDashWeb, :controller

  alias HomeDash.DataPoints.{ElectricityDataPoint, GasDataPoint}
  alias HomeDash.DataPoints
  action_fallback HomeDashWeb.FallbackController

  def index(conn, _params) do
    current = DataPoints.current()
    # send_resp(conn, 200, "OK")
    render(conn, "current.json", current)
  end
end
