defmodule HomeDashWeb.DataPointView do
  use HomeDashWeb, :view

  def render("current.json", %{gas: g, electricity: e}) do
    %{gas: g.value, electricity: e.value}
  end
end
