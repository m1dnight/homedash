defmodule Homedash.Repo.Migrations.CreateElectricityDatapoints do
  use Ecto.Migration

  def change do
    create table(:electricity_datapoints) do
      add :value, :float
      add :read_on, :utc_datetime

      timestamps()
    end
  end
end
