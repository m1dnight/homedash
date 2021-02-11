defmodule Homedash.Data.Solar do
  use Ecto.Schema
  import Ecto.Changeset

  schema "solar_datapoints" do
    field :value, :float
    field :read_on, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(solar_data_point, attrs) do
    solar_data_point
    |> cast(attrs, [:value, :read_on])
    |> validate_required([:value, :read_on])
  end
end
