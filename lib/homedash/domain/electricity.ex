defmodule Homedash.Data.Electricity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "electricity_datapoints" do
    field :value, :float
    field :read_on, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(electricity_data_point, attrs) do
    electricity_data_point
    |> cast(attrs, [:value, :read_on])
    |> validate_required([:value, :read_on])
  end
end
