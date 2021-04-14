defmodule Homedash.PubSub do
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(__MODULE__, @topic)
  end

  def notify_new_current({:current, injection, consumption}) do
    Phoenix.PubSub.broadcast(__MODULE__, @topic, {:current, injection, consumption})
    {:ok, {:current, injection, consumption}}
  end
end
