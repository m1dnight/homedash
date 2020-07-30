defmodule HomeDash.DataPoints.GasDataPoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gas_datapoints" do
    field :value, :float
    field :read_on, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(gas_data_point, attrs) do
    gas_data_point
    |> cast(attrs, [:value, :read_on])
    |> validate_required([:value, :read_on])
  end
end
