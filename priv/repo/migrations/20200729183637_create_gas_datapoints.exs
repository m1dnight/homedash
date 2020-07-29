defmodule HomeDash.Repo.Migrations.CreateGasDatapoints do
  use Ecto.Migration

  def change do
    create table(:gas_datapoints) do
      add :value, :float

      timestamps()
    end

  end
end
