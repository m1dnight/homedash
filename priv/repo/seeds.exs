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
