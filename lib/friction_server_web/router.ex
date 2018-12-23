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

    post "/token", TokenController, :add_token

    pipe_through :authenticated
    get "/users", UserController, :show
    put "/users", UserController, :update
    delete "/users/:id", UserController, :delete

    get "/polls", PollController, :show_all
    get "/polls/latest", PollController, :show_latest
    get "/polls/:id", PollController, :show
    post "/polls", PollController, :create
    put "/polls/:id", PollController, :update
    delete "/polls/:id", PollController, :delete

    post "/votes", PollController, :add_vote
    put "/votes/:id", PollController, :update_vote
    get "/votes", PollController, :show_votes

    get "/polls/:id/messages", PollController, :get_messages
    get "/polls/:id/claps", PollController, :get_claps
    post "/messages/:id/claps", MessageController, :add_claps

    post "/upload/image", UploadController, :upload
  end

  # Other scopes may use custom stacks.
  # scope "/api", FrictionServerWeb do
  #   pipe_through :api
  # end
end
