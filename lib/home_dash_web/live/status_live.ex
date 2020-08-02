defmodule HomeDashWeb.StatusLive do
  use HomeDashWeb, :live_view

  alias HomeDash.DataPoints

  def mount(_params, _seassion, socket) do
    # Only send a
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    {:ok, assign_stats(socket)}
  end

  def render(assigns) do
    ~L"""
    <div class="flex flex-wrap">
        <!--Metric Card-->
        <div class="w-full md:w-1/3 xl:w-1/3 p-3">
            <div class="bg-white border rounded shadow p-2">
                <div class="flex flex-row items-center">
                    <div class="flex-shrink pr-4">
                        <div class="rounded p-3 bg-red-600">
                            <i class="fa fa-burn fa-2x fa-fw fa-inverse"></i>
                        </div>
                    </div>
                    <div class="flex-1 text-right md:text-center">
                    <h2 class="font-bold text-3xl">Total</h2>
                        <h3 class="font-bold text-3xl"> <%= @gas.value |> show_measurement(3) %> m<sup>3</sup></h3>
                        <p class="text-gray-500">Last update: <%= format_datetime(@electricity.read_on) %></p>

                    </div>
                </div>
            </div>
        </div>

        <!--Metric Card-->
        <div class="w-full md:w-1/3 xl:w-1/3 p-3">
            <div class="bg-white border rounded shadow p-2">
                <div class="flex flex-row items-center">
                    <div class="flex-shrink pr-4">
                        <div class="rounded p-3 bg-yellow-300">
                            <i class="fa fa-bolt fa-2x fa-fw fa-inverse"></i>
                        </div>
                    </div>
                    <div class="flex-1 text-right md:text-center">
                    <h2 class="font-bold text-3xl">Total</h2>
                        <h3 class="font-bold text-3xl"> <%= @electricity.value  |> show_measurement(3)%> kW</h3>
                        <p class="text-gray-500">Last update: <%= format_datetime(@electricity.read_on) %></p>
                    </div>
                </div>
            </div>
        </div>

        <!--Metric Card-->
        <div class="w-full md:w-1/3 xl:w-1/3 p-3">
            <div class="bg-white border rounded shadow p-2">
                <div class="flex flex-row items-center">
                    <div class="flex-shrink pr-4">
                        <div class="rounded p-3 bg-yellow-300">
                            <i class="fa fa-sun fa-2x fa-fw fa-inverse"></i>
                        </div>
                    </div>
                    <div class="flex-1 text-right md:text-center">
                    <h2 class="font-bold text-3xl">Total</h2>
                        <h3 class="font-bold text-3xl"> <%= @solar.value  |> show_measurement(3)%> kW</h3>
                        <p class="text-gray-500">Last update: <%= format_datetime(@solar.read_on) %></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="flex flex-wrap">
        <!--Metric Card-->
        <div class="w-full md:w-1/3 xl:w-1/3 p-3">
            <div class="bg-white border rounded shadow p-2">
                <div class="flex flex-row items-center">
                    <div class="flex-shrink pr-4">
                        <div class="rounded p-3 bg-red-600">
                            <i class="fa fa-burn fa-2x fa-fw fa-inverse"></i>
                        </div>
                    </div>
                    <div class="flex-1 text-right md:text-center">
                        <h2 class="font-bold text-3xl">Today</h2>
                        <h3 class="font-bold text-3xl"> <%= @gas_today |> show_measurement(3) %> m<sup>3</sup></h3>

                    </div>
                </div>
            </div>
        </div>

        <!--Metric Card-->
        <div class="w-full md:w-1/3 xl:w-1/3 p-3">
            <div class="bg-white border rounded shadow p-2">
                <div class="flex flex-row items-center">
                    <div class="flex-shrink pr-4">
                        <div class="rounded p-3 bg-yellow-300">
                            <i class="fa fa-bolt fa-2x fa-fw fa-inverse"></i>
                        </div>
                    </div>
                    <div class="flex-1 text-right md:text-center">
                        <h2 class="font-bold text-3xl">Today</h2>
                        <h3 class="font-bold text-3xl"> <%= @electricity_today |> show_measurement(3)%> kW</h3>
                    </div>
                </div>
            </div>
        </div>

        <!--Metric Card-->
        <div class="w-full md:w-1/3 xl:w-1/3 p-3">
            <div class="bg-white border rounded shadow p-2">
                <div class="flex flex-row items-center">
                    <div class="flex-shrink pr-4">
                        <div class="rounded p-3 bg-yellow-300">
                            <i class="fa fa-sun fa-2x fa-fw fa-inverse"></i>
                        </div>
                    </div>
                    <div class="flex-1 text-right md:text-center">
                        <h2 class="font-bold text-3xl">Today</h2>
                        <h3 class="font-bold text-3xl"> <%= @solar_today  |> show_measurement(3)%> kW</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>

    """
  end

  def handle_info(:tick, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  defp assign_stats(socket) do
    %{gas: g, electricity: e, solar: s, solar_today: std, gas_today: gtd, electricity_today: etd} =
      DataPoints.current()

    socket
    |> assign(
      electricity: e,
      gas: g,
      solar: s,
      solar_today: std,
      electricity_today: etd,
      gas_today: gtd
    )
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
end
