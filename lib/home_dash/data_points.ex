defmodule HomeDash.DataPoints do
  require HomeDash.DataPoints.Macros
  import HomeDash.DataPoints.Macros
  import Ecto.Query, warn: false
  alias HomeDash.Repo



  alias HomeDash.DataPoints.{GasDataPoint, ElectricityDataPoint, SolarDataPoint}


  def current() do
    electricity = last_electricity_reading()
    electricity_today = total_electricity_today()
    gas = last_gas_reading()
    gas_today = total_gas_today()
    solar = last_solar_reading()
    solar_today = total_solar_today()

    %{
      gas: gas,
      electricity: electricity,
      solar: solar,
      electricity_today: electricity_today,
      gas_today: gas_today,
      solar_today: solar_today
    }
  end

  datapoint "electricity", ElectricityDataPoint
  datapoint "gas", GasDataPoint
  datapoint "solar", SolarDataPoint

  ##############################################################################
  # Helpers ####################################################################
  ##############################################################################

  @spec start_of_day :: DateTime.t()
  def start_of_day() do
    DateTime.now!("Etc/UTC")
    |> Map.put(:hour, 0)
    |> Map.put(:minute, 0)
    |> Map.put(:second, 0)
    |> Map.put(:microsecond, {0, 0})
  end
end
