defmodule HomedashWeb.PageView do
  use HomedashWeb, :view

  def labels_day(measurements) do
    measurements
    |> Enum.map(fn v = %{read_on_group_local: dt} ->
      day = "#{dt.day}"
      month = "#{dt.month}" |> String.pad_leading(2, "0")
      "#{day}/#{month}"
    end)
    |> Jason.encode!()
  end

  def labels_hour(measurements) do
    measurements
    |> Enum.map(fn %{read_on_group_local: dt} ->
      hour = "#{dt.hour}" |> String.pad_leading(2, "0")
      minute = "#{dt.minute}" |> String.pad_leading(2, "0")
      "#{hour}:#{minute}"
    end)
    |> Jason.encode!()
  end

  def values_recent(measurements) do
    measurements
    |> Enum.map(fn %{min: mn, max: mx} ->
      "#{round((mx - mn) * 100) / 100}"
    end)
    |> Jason.encode!()
  end

  def format_float(float) do
    trunc(float * 100) / 100
  end

  def format_datetime(dt) do
    hour = "#{dt.hour}" |> String.pad_leading(2, "0")
    minute = "#{dt.minute}" |> String.pad_leading(2, "0")
    second = "#{dt.second}" |> String.pad_leading(2, "0")
    "#{dt.day}/#{dt.month}/#{dt.year} #{hour}:#{minute}:#{second}"
  end
end
