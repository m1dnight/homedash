defmodule HomeDash.DataPoints do
  import Ecto.Query, warn: false
  alias HomeDash.Repo

  alias HomeDash.DataPoints.{GasDataPoint, ElectricityDataPoint}

  def current() do
    electricity = ElectricityDataPoint |> last() |> Repo.one()
    gas = GasDataPoint |> last() |> Repo.one()

    %{gas: gas, electricity: electricity}
  end

  ##############################################################################
  # Electricity ################################################################
  ##############################################################################

  def last_electricity_datapoint() do
  end

  def list_electricity_datapoints do
    Repo.all(ElectricityDataPoint)
  end

  def create_electricity_data_point(attrs \\ %{}) do
    %ElectricityDataPoint{}
    |> ElectricityDataPoint.changeset(attrs)
    |> Repo.insert()
  end

  def delete_electricity_data_point(%ElectricityDataPoint{} = electricity_data_point) do
    Repo.delete(electricity_data_point)
  end

  def change_electricity_data_point(
        %ElectricityDataPoint{} = electricity_data_point,
        attrs \\ %{}
      ) do
    ElectricityDataPoint.changeset(electricity_data_point, attrs)
  end

  ##############################################################################
  # Gas ########################################################################
  ##############################################################################

  def list_gas_datapoints do
    Repo.all(GasDataPoint)
  end

  def create_gas_data_point(attrs \\ %{}) do
    %GasDataPoint{}
    |> GasDataPoint.changeset(attrs)
    |> Repo.insert()
  end

  def delete_gas_data_point(%GasDataPoint{} = gas_data_point) do
    Repo.delete(gas_data_point)
  end

  def change_gas_data_point(
        %GasDataPoint{} = gas_data_point,
        attrs \\ %{}
      ) do
    GasDataPoint.changeset(gas_data_point, attrs)
  end
end
