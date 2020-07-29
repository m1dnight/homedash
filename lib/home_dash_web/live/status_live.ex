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
        <button phx-click="refresh">
          <img src="images/refresh.svg">
          Refresh
        </button>
      </div>
      <div class="flex flex-wrap">
        <!--Metric Card-->
        <div class="w-full md:w-1/2 xl:w-1/2 p-3">
            <div class="bg-white border rounded shadow p-2">
                <div class="flex flex-row items-center">
                    <div class="flex-shrink pr-4">
                        <div class="rounded p-3 bg-red-600">
                            <i class="fa fa-burn fa-2x fa-fw fa-inverse"></i>
                        </div>
                    </div>
                    <div class="flex-1 text-right md:text-center">
                        <h5 class="font-bold uppercase text-gray-500">Total Gas Consumption</h5>
                        <h3 class="font-bold text-3xl"> <%= @gas %> m<sup>3</sup></h3>
                    </div>
                </div>
            </div>
        </div>

        <!--Metric Card-->
        <div class="w-full md:w-1/2 xl:w-1/2 p-3">
            <div class="bg-white border rounded shadow p-2">
                <div class="flex flex-row items-center">
                    <div class="flex-shrink pr-4">
                        <div class="rounded p-3 bg-yellow-300">
                            <i class="fa fa-bolt fa-2x fa-fw fa-inverse"></i>
                        </div>
                    </div>
                    <div class="flex-1 text-right md:text-center">
                        <h5 class="font-bold uppercase text-gray-500">Total Electricity Consumption</h5>
                        <h3 class="font-bold text-3xl"> <%= @electricity %> kW</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>
    """
  end

  def handle_event("refresh", _, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  defp assign_stats(socket) do
    %{gas: g, electricity: e} = DataPoints.current()
    socket = socket |> assign(electricity: e.value, gas: g.value)
  end
end
