defmodule HomedashWeb.Live do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="row mt-1">
      <div class="col-6">
        <h5 class="card-title text-center">
        <span phx-update="ignore" class="green" data-feather="sun"></span>
        <%= @injection |> format_float() %> kW</h5>
      </div>
      <div class="col-6">
        <h5 class="card-title text-center">
        <span phx-update="ignore" class="yellow" data-feather="zap"></span>
        <%= @consumption |> format_float() %> kW</h5>
      </div>
    </div>
    """
  end

  def format_float(float) do
    trunc(float * 100) / 100
  end

  def handle_info({:current, injection, consumption}, socket) do
    socket =
      socket
      |> assign(:consumption, consumption)
      |> assign(:injection, injection)

    {:noreply, socket}
  end

  def mount(_params, _vals, socket) do
    # Subscribe to updates from the channel.
    Homedash.PubSub.subscribe()

    socket =
      socket
      |> assign(:consumption, 0.0)
      |> assign(:injection, 0.0)

    {:ok, socket}
  end
end
