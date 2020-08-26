# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HomeDash.Repo.insert!(%HomeDash.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HomeDash.DataPoints

now = DateTime.from_unix!(0)

DataPoints.create_electricity_data_point(%{value: 0, read_on: now})
DataPoints.create_gas_data_point(%{value: 0, read_on: now})
DataPoints.create_solar_data_point(%{value: 0, read_on: now})

# Historic data

# 10..0
# |> Enum.flat_map(fn day ->
#   3..0
#   |> Enum.map(fn hour ->
#     # Generate a timestamp today to 10 days back
#     # Generate a value at 1 am, 2 am, and 3 am
#     date =
#       DateTime.now!("Etc/UTC")
#       |> DateTime.add(-1 * day * 24 * 60 * 60, :second, Calendar.get_time_zone_database())
#       |> DateTime.add(hour * 60 * 60, :second, Calendar.get_time_zone_database())

#     IO.puts(date)

#     DataPoints.create_electricity_data_point(%{value: day * 100 + hour * 10, read_on: date})
#     DataPoints.create_gas_data_point(%{value: 1000 + day * 100 + hour * 100, read_on: date})
#     DataPoints.create_solar_data_point(%{value: 2000 + day * 100 + hour * 1000, read_on: date})
#   end)
# end)

# Data for today.
# One reading every 5 minutes every hour.
# 0..23
# |> Enum.map(fn hour ->
#   0..11
#   |> Enum.map(fn minute ->
#     minutes = minute * 5

#     date =
#       DateTime.now!("Etc/UTC")
#       |> Map.put(:hour, hour)
#       |> Map.put(:minute, minutes)

#     value = hour * 100 + minutes
#     IO.inspect "#{value} @ #{inspect date}"
#     # DataPoints.create_electricity_data_point(%{value: value, read_on: date})
#     # DataPoints.create_gas_data_point(%{value: value, read_on: date})
#     # DataPoints.create_solar_data_point(%{value: value, read_on: date})
#   end)
# end)

# Insert values up to 8 hours back.
# Insert a reading every 5 minutes, that means 8 * 60 / 5 measurements total.

1..trunc(8 * 60 / 5)
|> Enum.reduce(1000, fn reading_idx, acc ->
  # Generate a timestamp today to 10 days back
  # Generate a value at 1 am, 2 am, and 3 am
  date =
    DateTime.now!("Etc/UTC")
    |> DateTime.add(-1 * reading_idx * 5 * 60, :second, Calendar.get_time_zone_database())

  value_gas = acc - :rand.uniform(5)
  value_ele = acc - :rand.uniform(5)
  value_sol = acc - :rand.uniform(5)
  DataPoints.create_electricity_data_point(%{value: value_ele, read_on: date})
  DataPoints.create_gas_data_point(%{value: value_gas, read_on: date})
  DataPoints.create_solar_data_point(%{value: value_sol, read_on: date})
  min(min(value_gas, value_ele), value_sol)
end)

# 0..23
# |> Enum.map(fn hour ->
#   date =
#     DateTime.now!("Etc/UTC")
#     |> Map.put(:hour, hour)
#     |> Map.put(:minute, 30)

#   DataPoints.create_electricity_data_point(%{value: hour * 10 + 2, read_on: date})
#   DataPoints.create_gas_data_point(%{value: hour * 10 + 2, read_on: date})
#   DataPoints.create_solar_data_point(%{value: hour * 10 + 2, read_on: date})
# end)

# 0..23
# |> Enum.map(fn hour ->
#   date =
#     DateTime.now!("Etc/UTC")
#     |> Map.put(:hour, hour)
#     |> Map.put(:minute, 45)

#   DataPoints.create_electricity_data_point(%{value: hour * 10 + 5, read_on: date})
#   DataPoints.create_gas_data_point(%{value: hour * 10 + 5, read_on: date})
#   DataPoints.create_solar_data_point(%{value: hour * 10 + 5, read_on: date})
# end)
