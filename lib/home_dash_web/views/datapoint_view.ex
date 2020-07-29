defmodule HomeDashWeb.DataPointView do
  use HomeDashWeb, :view
  alias HomeDashWeb.UserView


  def render("current.json", %{gas: g, electricity: e}) do
    %{gas: g.value, electricity: e.value}
  end
end
