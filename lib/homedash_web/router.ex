defmodule HomedashWeb.Router do
  use HomedashWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug HomedashWeb.Token, exclude: ["/api/meters"]
  end

  scope "/api", HomedashWeb do
    pipe_through :api

    get "/meters", ApiController, :index
    post "/electricity", ApiController, :create_electricity_datapoint
    post "/gas", ApiController, :create_gas_datapoint
    post "/solar", ApiController, :create_solar_datapoint
    post "/current", ApiController, :current
  end

  scope "/", HomedashWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/historical", PageController, :historical
    get "/insight", PageController, :insight
    get "/edash", PageController, :edash
    get "/debug", PageController, :debug
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomedashWeb do
  #   pipe_through :api
  # end
end
