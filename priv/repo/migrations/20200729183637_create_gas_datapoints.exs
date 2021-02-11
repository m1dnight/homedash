defmodule Homedash.Repo.Migrations.CreateGasDatapoints do
  use Ecto.Migration

  def change do
    create table(:gas_datapoints) do
      add :value, :float
      add :read_on, :utc_datetime

      timestamps()
    end
  end
end
