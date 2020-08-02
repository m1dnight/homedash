defmodule HomeDash.DataPoints do
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

  ##############################################################################
  # Electricity ################################################################
  ##############################################################################

  def list_electricity_datapoints do
    Repo.all(ElectricityDataPoint)
  end

  def last_electricity_reading() do
    query =
      (from dp in ElectricityDataPoint,
        order_by: [desc: :read_on])
        |> first()

    Repo.all(query)
  end

  def total_electricity_today() do
    today = list_electricity_datapoints_since(start_of_day())

    case today do
      [] ->
        0.0

      [reading] ->
        reading.value

      _ ->
        last_measurement = List.last(today)
        first_measurement = List.first(today)
        last_measurement.value - first_measurement.value
    end
  end

  def list_electricity_datapoints_since(start) do
    list_electricity_datapoints_between(start, DateTime.now!("Etc/UTC"))
  end

  def list_electricity_datapoints_between(start, finish) do
    query =
      from dp in ElectricityDataPoint,
        where: dp.read_on > ^start and dp.read_on < ^finish

    Repo.all(query)
  end

  def create_electricity_data_point(attrs \\ %{}) do
    %ElectricityDataPoint{}
    |> ElectricityDataPoint.changeset(attrs)
    |> Repo.insert()
  end

  def delete_electricity_data_point(%ElectricityDataPoint{} = electricity_data_point) do
    Repo.delete(electricity_data_point)
  end

  @spec change_electricity_data_point(
          HomeDash.DataPoints.ElectricityDataPoint.t(),
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
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

  def last_gas_reading() do
    query =
      (from dp in GasDataPoint,
        order_by: [desc: :read_on])
        |> first()

    Repo.all(query)
  end

  def total_gas_today() do
    today = list_gas_datapoints_since(start_of_day())

    case today do
      [] ->
        0.0

      [reading] ->
        reading.value

      _ ->
        last_measurement = List.last(today)
        first_measurement = List.first(today)
        last_measurement.value - first_measurement.value
    end
  end

  def list_gas_datapoints_since(start) do
    list_gas_datapoints_between(start, DateTime.now!("Etc/UTC"))
  end

  def list_gas_datapoints_between(start, finish) do
    query =
      from dp in GasDataPoint,
        where: dp.read_on > ^start and dp.read_on < ^finish

    Repo.all(query)
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

  ##############################################################################
  # Solar ######################################################################
  ##############################################################################

  def list_solar_datapoints do
    Repo.all(SolarDataPoint)
  end

  def last_solar_reading() do
    query =
      (from dp in SolarDataPoint,
        order_by: [desc: :read_on])
        |> first()

    Repo.all(query)
  end

  def total_solar_today() do
    today = list_solar_datapoints_since(start_of_day())

    case today do
      [] ->
        0.0

      [reading] ->
        reading.value

      _ ->
        last_measurement = List.last(today)
        first_measurement = List.first(today)
        last_measurement.value - first_measurement.value
    end
  end

  def list_solar_datapoints_since(start) do
    list_solar_datapoints_between(start, DateTime.now!("Etc/UTC"))
  end

  def list_solar_datapoints_between(start, finish) do
    query =
      from dp in SolarDataPoint,
        where: dp.read_on > ^start and dp.read_on < ^finish

    Repo.all(query)
  end

  def create_solar_data_point(attrs \\ %{}) do
    %SolarDataPoint{}
    |> SolarDataPoint.changeset(attrs)
    |> Repo.insert()
  end

  def delete_solar_data_point(%SolarDataPoint{} = solar_data_point) do
    Repo.delete(solar_data_point)
  end

  def change_solar_data_point(
        %SolarDataPoint{} = solar_data_point,
        attrs \\ %{}
      ) do
    SolarDataPoint.changeset(solar_data_point, attrs)
  end

  ##############################################################################
  # Helpers ####################################################################
  ##############################################################################

  def start_of_day() do
    DateTime.now!("Etc/UTC")
    |> Map.put(:hour, 0)
    |> Map.put(:minute, 0)
    |> Map.put(:second, 0)
    |> Map.put(:microsecond, {0, 0})
  end
end
