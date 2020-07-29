defmodule HomeDashWeb.DataPointController do
  use HomeDashWeb, :controller

  alias HomeDash.DataPoints.{ElectricityDataPoint, GasDataPoint}
  alias HomeDash.DataPoints
  action_fallback HomeDashWeb.FallbackController

  def index(conn, _params) do
    current = DataPoints.current()
    render(conn, "current.json", current)
  end

  def create_electricity_datapoint(conn, %{"value" => _value} = params) do
    with {:ok, %ElectricityDataPoint{}} <- DataPoints.create_electricity_data_point(params) do
      conn
      |> put_status(:created) # what does this do? :)
      |> send_resp(200, "OK")
    end
  end

  def create_gas_datapoint(conn, %{"value" => _value} = params) do
    with {:ok, %GasDataPoint{}} <- DataPoints.create_gas_data_point(params) do
      conn
      |> put_status(:created) # what does this do? :)
      |> send_resp(200, "OK")
    end
  end

end
