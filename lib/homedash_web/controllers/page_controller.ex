defmodule HomedashWeb.PageController do
  use HomedashWeb, :controller
  plug :put_layout, false when action in [:edash, :debug]

  import Homedash.Data

  def index(conn, _params) do
    data = %{
      :last => latest_measurement(),
      :totals => %{
        :gas => meter_reading_gas(),
        :electricity => meter_reading_electricity(),
        :solar => meter_reading_solar()
      },
      :recent => %{
        :solar => recent_solar(1),
        :gas => recent_gas(1),
        :electricity => recent_electricity(1)
      },
      :gas_today => gas_today(),
      :solar_today => solar_today(),
      :electricity_today => electricity_today(),
      :gas_yearly_avg => gas_daily_average(365),
      :gas_monthly_avg => gas_daily_average(30),
      :gas_weekly_avg => gas_daily_average(7),
      :electricity_yearly_avg => electricity_daily_average(365),
      :electricity_monthly_avg => electricity_daily_average(30),
      :electricity_weekly_avg => electricity_daily_average(7),
      :solar_yearly_avg => solar_daily_average(365),
      :solar_monthly_avg => solar_daily_average(30),
      :solar_weekly_avg => solar_daily_average(7)
    }

    render(conn, "index.html", data: data)
  end

  def historical(conn, _params) do
    data = %{
      :gas => historical_gas(30),
      :solar => historical_solar(30),
      :electricity => historical_electricity(30),
      :electricity7 => electricity_daily_average(7),
      :electricity30 => electricity_daily_average(30),
      :electricity365 => electricity_daily_average(365),
      :gas7 => gas_daily_average(7),
      :gas30 => gas_daily_average(30),
      :gas365 => gas_daily_average(365),
      :solar7 => solar_daily_average(7),
      :solar30 => solar_daily_average(30),
      :solar365 => solar_daily_average(365)
    }

    render(conn, "historical.html", data: data)
  end

  def insight(conn, _params) do
    data = %{
      :gas_today => gas_today(),
      :gas_average_30 => gas_daily_average(30),
      :gas_average_90 => gas_daily_average(90),
      :solar_today => solar_today(),
      :solar_average_30 => solar_daily_average(30),
      :solar_average_90 => solar_daily_average(90),
      :electricity_today => electricity_today(),
      :electricity_average_30 => electricity_daily_average(30),
      :electricity_average_90 => electricity_daily_average(90)
    }

    render(conn, "insight.html", data: data)
  end

  def debug(conn, _params) do
    render(conn, "debug.html", content: inspect(debug(), pretty: true))
  end

  def edash(conn, _params) do
    data = %{
      :gas => historical_gas(7),
      :solar => historical_solar(7),
      :electricity => historical_electricity(7),
      :today => %{
        :gas => gas_today(),
        :solar => solar_today(),
        :electricity => electricity_today()
      },
      :totals => %{
        :gas => meter_reading_gas(),
        :electricity => meter_reading_electricity(),
        :solar => meter_reading_solar()
      },
      :averages => %{
        :gas => gas_daily_average(),
        :solar => solar_daily_average(),
        :electricity => electricity_daily_average()
      },
      :last => latest_measurement()
    }

    render(conn, "edash.html", data: data, height: 370 * 1, width: 640 * 1)
  end
end
