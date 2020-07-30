defmodule HomeDash.Repo.Migrations.CreateElectricityDatapoints do
  use Ecto.Migration

  def change do
    create table(:electricity_datapoints) do
      add :value, :float

      timestamps()
    end
  end
end
