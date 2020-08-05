defmodule HomeDashWeb.PageView do
  use HomeDashWeb, :view

  def format_datetime(dt) do
    hour = "#{dt.hour}" |> String.pad_leading(2, "0")
    minute = "#{dt.minute}" |> String.pad_leading(2, "0")
    second = "#{dt.second}" |> String.pad_leading(2, "0")
    "#{dt.day}/#{dt.month}/#{dt.year} #{hour}:#{minute}:#{second}"
  end

  def show_measurement(float, decimals) do
    float |> Float.ceil(decimals)
  end

  # Day usage charts.
  def labels(dataset) do
    IO.inspect(dataset)

    dataset
    |> Enum.map(fn {date, _value} ->
      day = String.pad_leading("#{date.day}", 2, "0")
      month = String.pad_leading("#{date.month}", 2, "0")
      ~s("#{day}/#{month}")
    end)
    |> Enum.join(", ")
  end

  def values(dataset) do
    dataset
    |> Enum.map(fn {_date, value} -> "#{value}" end)
    |> Enum.join(", ")
  end
end
