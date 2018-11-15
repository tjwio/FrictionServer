defmodule FrictionServerWeb.Router do
  use FrictionServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug FrictionServer.Pipelines.Auth
  end

  scope "/api/v1", FrictionServerWeb do
    pipe_through :api

    post "/users/signup", UserController, :create
    post "/users/login", UserController, :login

    pipe_through :authenticated
    get "/users", UserController, :show
    put "/users", UserController, :update_user
    delete "/users", UserController, :delete

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", FrictionServerWeb do
  #   pipe_through :api
  # end
end
