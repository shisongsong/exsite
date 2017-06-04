defmodule Exsite.Router do
  use Exsite.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Exsite.Auth, repo: Exsite.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :put_secure_browser_headers
  end

  scope "/api", Exsite do
    pipe_through :api
    delete "/sessions/:user_id", SessionController, :delete
    post "/images", ImageController, :create
  end

  scope "/", Exsite do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create]
    resources "/topics", TopicController 
    resources "/posts", PostController do
      resources "/comments", CommentController, only: [:new, :create, :eidt, :update]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Exsite do
  #   pipe_through :api
  # end
end
