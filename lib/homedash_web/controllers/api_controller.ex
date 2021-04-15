defmodule HomedashWeb.ApiController do
  use HomedashWeb, :controller
  require Logger

  alias Homedash.Data
  action_fallback HomedashWeb.FallbackController

  alias Homedash.Data.{Electricity, Gas, Solar}

  def index(conn, _params) do
    data = %{
      :totals => %{
        :gas => Data.meter_reading_gas(),
        :electricity => Data.meter_reading_electricity(),
        :solar => Data.meter_reading_solar()
      }
    }

    render(conn, "current.json", data)
  end

  def current(conn, %{"actual_injection" => inj, "actual_consumption" => con}) do
    Homedash.PubSub.notify_new_current({:current, inj, con})
    send_resp(conn, 200, "OK")
  end

  def create_electricity_datapoint(conn, %{"value" => value, "read_on" => ro}) do
    {:ok, ro, 0} = DateTime.from_iso8601(ro)
    params = %{"value" => value, "read_on" => ro}

    with {:ok, %Electricity{}} <- Data.insert_electricity(params) do
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

  def create_solar_datapoint(conn, %{"value" => value, "read_on" => ro}) do
    Logger.debug("Storing measurement through API: #{value} @ #{inspect(ro)}")
    {:ok, ro, 0} = DateTime.from_iso8601(ro)
    params = %{"value" => value, "read_on" => ro}

    with {:ok, %Solar{}} <- Data.insert_solar(params) do
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
    {:ok, ro, 0} = DateTime.from_iso8601(ro)
    params = %{"value" => value, "read_on" => ro}

    with {:ok, %Gas{}} <- Data.insert_gas(params) do
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
end
