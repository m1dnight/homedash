defmodule HomeDash.DataPoints.GasDataPoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gas_datapoints" do
    field :value, :float

    timestamps()
  end

  @doc false
  def changeset(gas_data_point, attrs) do
    gas_data_point
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
