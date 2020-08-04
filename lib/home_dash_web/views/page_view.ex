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
end
