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
    dataset
    |> Enum.map(fn {_value, date} ->
      ~s("#{date.day}/#{date.month}")
    end)
    |> Enum.join(", ")
  end

  def values(dataset) do
    dataset
    |> Enum.map(fn {value, _date} -> "#{value}" end)
    |> Enum.join(", ")
  end
end
