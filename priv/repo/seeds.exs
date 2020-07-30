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

DataPoints.create_electricity_data_point(%{value: 0})
DataPoints.create_gas_data_point(%{value: 0})
