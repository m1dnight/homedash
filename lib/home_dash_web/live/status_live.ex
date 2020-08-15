defmodule HomeDashWeb.StatusLive do
  use HomeDashWeb, :live_view

  alias HomeDash.DataPoints

  def mount(_params, _seassion, socket) do
    # Only send a
    if connected?(socket) do
      #   :timer.send_interval(1000, self(), :tick)
    end

    {:ok, assign_stats(socket)}
  end

  def handle_info(:tick, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  defp assign_stats(socket) do
    socket
    |> assign(current: HomeDash.DataPoints.current())
  end

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
    |> Enum.map(fn {date, _value} ->
      day = String.pad_leading("#{date.day}", 2, "0")
      month = String.pad_leading("#{date.month}", 2, "0")
      ~s("#{day}/#{month}")
    end)
    |> Enum.join(", ")
  end

  # Hourly charts
  def labels_hourly(dataset) do
    dataset
    |> Enum.map(fn {date, _value} ->
      hour = String.pad_leading("#{date.hour}", 2, "0")
      ~s("#{hour}:00")
    end)
    |> Enum.join(", ")
  end

  # Quarterly charts
  def labels_quarterly(dataset) do
    dataset
    |> Enum.map(fn {date, _value} ->
      hour = String.pad_leading("#{date.hour}", 2, "0")
      minute = String.pad_leading("#{date.minute}", 2, "0")
      ~s("#{hour}:#{minute}")
    end)
    |> Enum.join(", ")
  end

  def values(dataset) do
    dataset
    |> Enum.map(fn {date, value} -> {date, show_measurement(value, 2)} end)
    |> Enum.map(fn {_date, value} -> "#{value}" end)
    |> Enum.join(", ")
  end
end
