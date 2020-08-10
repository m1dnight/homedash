defmodule HomeDash.DataPoints do
  require HomeDash.DataPoints.Macros
  import HomeDash.DataPoints.Macros
  import Ecto.Query, warn: false

  alias HomeDash.DataPoints.{GasDataPoint, ElectricityDataPoint, SolarDataPoint}

  def current() do
    electricity = last_electricity_reading()
    electricity_today = total_electricity_today()
    electricity_totals = list_electricity_day_totals_last_n_days(7)
    electricity_hourly = total_electricity_hourly()
    gas = last_gas_reading()
    gas_today = total_gas_today()
    gas_totals = list_gas_day_totals_last_n_days(7)
    gas_hourly = total_gas_hourly()
    solar = last_solar_reading()
    solar_today = total_solar_today()
    solar_totals = list_solar_day_totals_last_n_days(7)
    solar_hourly = total_solar_hourly()


    %{
      gas: gas,
      electricity: electricity,
      solar: solar,
      electricity_today: electricity_today,
      gas_today: gas_today,
      solar_today: solar_today,
      electricity_totals: electricity_totals,
      solar_totals: solar_totals,
      gas_totals: gas_totals,
      electricity_hourly: electricity_hourly,
      gas_hourly: gas_hourly,
      solar_hourly: solar_hourly
    }
  end

  datapoint("electricity", ElectricityDataPoint)
  datapoint("gas", GasDataPoint)
  datapoint("solar", SolarDataPoint)


  def test() do
    today = list_electricity_datapoints_since(start_of_day())

    grouped =
      today
      |> Enum.group_by(fn measurement ->
        measurement.read_on |> truncate_datetime_hour()
      end)
      |> Enum.map(fn {hour, values} ->
        # First reading
        first = values |> Enum.sort_by(fn reading -> reading.read_on end) |> List.first()
        last = values |> Enum.sort_by(fn reading -> reading.read_on end) |> List.last()
        consumption = last.value - first.value
        {hour, consumption}
      end)
  end
  ##############################################################################
  # Helpers ####################################################################
  ##############################################################################

  # @spec start_of_day :: DateTime.t()
  def start_of_day(day \\ nil) do
    day = if day, do: day, else: DateTime.now!("Etc/UTC")

    day
    |> Map.put(:hour, 0)
    |> Map.put(:minute, 0)
    |> Map.put(:second, 0)
    |> Map.put(:microsecond, {0, 0})
  end

  def start_of_next_day(day \\ nil) do
    day = if day, do: day, else: DateTime.now!("Etc/UTC")

    day
    |> start_of_day()
    |> DateTime.add(24 * 60 * 60, :second, Calendar.get_time_zone_database())
  end

  def end_of_day(day \\ nil) do
    day = if day, do: day, else: DateTime.now!("Etc/UTC")

    day
    |> Map.put(:hour, 23)
    |> Map.put(:minute, 59)
    |> Map.put(:second, 59)
    |> Map.put(:microsecond, {0, 0})
  end

  def truncate_datetime_hour(datetime) do
    datetime
    |> Map.put(:minute, 0)
    |> Map.put(:second, 0)
    |> Map.put(:microsecond, {0, 0})
  end
end
