defmodule Babygenius.Router do
  use Babygenius.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    if Mix.env == :prod do # You don't want this to run in dev & test.
      plug LessVerifiesAlexa.Plug, application_id: System.get_env("ALEXA_APPLICATION_ID")
    end
  end

  scope "/", Babygenius do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
   scope "/api", Babygenius dk
     pipe_through :api

     post "/", AlexaController, :command
   end
end
