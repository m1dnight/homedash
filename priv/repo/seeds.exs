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

# now = DateTime.from_unix!(0)

# DataPoints.create_electricity_data_point(%{value: 0, read_on: now})
# DataPoints.create_gas_data_point(%{value: 0, read_on: now})
# DataPoints.create_solar_data_point(%{value: 0, read_on: now})

# 0..10
# |> Enum.flat_map(fn day ->
#   1..3
#   |> Enum.map(fn hour ->
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
