defmodule HomeDash.DataPoints.ElectricityDataPoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "electricity_datapoints" do
    field :value, :float

    timestamps()
  end

  @doc false
  def changeset(electricity_data_point, attrs) do
    electricity_data_point
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
