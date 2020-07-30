defmodule HomeDash.Repo.Migrations.CreateSolarDatapoints do
  use Ecto.Migration

  def change do
    create table(:solar_datapoints) do
      add :value, :float
      add :read_on, :utc_datetime

      timestamps()
    end
  end
end
