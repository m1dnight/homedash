defmodule HomeDashWeb.DataPointController do
  use HomeDashWeb, :controller

  alias HomeDash.DataPoints.{ElectricityDataPoint, GasDataPoint, SolarDataPoint}
  alias HomeDash.DataPoints
  action_fallback HomeDashWeb.FallbackController

  def index(conn, _params) do
    current = DataPoints.current()
    render(conn, "current.json", current)
  end

  def create_electricity_datapoint(conn, %{"value" => value, "read_on" => ro}) do
    {:ok, ro, 0} = DateTime.from_iso8601(ro)
    params = %{"value" => value, "read_on" => ro}

    with {:ok, %ElectricityDataPoint{}} <- DataPoints.create_electricity_data_point(params) do
      conn
      # what does this do? :)
      |> put_status(:created)
      |> send_resp(200, "OK")
    else
      _ ->
        conn
        |> send_resp(500, "Invalid input given.")
    end
  end

  def create_gas_datapoint(conn, %{"value" => value, "read_on" => ro}) do
    # 0 offset because we want UTC!
    {:ok, ro, 0} = DateTime.from_iso8601(ro)
    params = %{"value" => value, "read_on" => ro}

    with {:ok, %GasDataPoint{}} <- DataPoints.create_gas_data_point(params) do
      conn
      # what does this do? :)
      |> put_status(:created)
      |> send_resp(200, "OK")
    end
  end

  def create_solar_datapoint(conn, %{"value" => value, "read_on" => ro}) do
    # 0 offset because we want UTC!
    {:ok, ro, 0} = DateTime.from_iso8601(ro)
    params = %{"value" => value, "read_on" => ro}

    with {:ok, %SolarDataPoint{}} <- DataPoints.create_solar_data_point(params) do
      conn
      # what does this do? :)
      |> put_status(:created)
      |> send_resp(200, "OK")
    end
  end
end
