defmodule HomedashWeb.ApiView do
  use HomedashWeb, :view

  def render("current.json", %{gas: g, electricity: e, solar: s}) do
    %{gas: g, electricity: e, solar: s}
  end
end
