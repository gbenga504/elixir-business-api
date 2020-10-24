defmodule BusiApiWeb.Router do
  use BusiApiWeb, :router
  import BusiApiWeb.Auth.Plug, only: [verify_cookie_refresh_token: 2]

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :auth do
    plug BusiApiWeb.Auth.Pipeline
    plug BusiApiWeb.Auth.Plug
    plug :verify_cookie_refresh_token
  end

  scope "/api", BusiApiWeb do
    pipe_through :api
    post "/users/signup", UserController, :create
    post "/users/login", SessionController, :create
    put "/users/refresh", SessionController, :update
    delete "/users/logout", SessionController, :delete
    post "/users/forgot-password", PasswordResetController, :create
    patch "/users/reset-password", PasswordResetController, :update
  end

  scope "/api", BusiApiWeb do
    pipe_through [:api, :auth]
    resources "/businesses", BusinessController, except: [:new, :edit]
    patch "/users/avatar", UserController, :update_avatar
    delete "/users/avatar", UserController, :delete_avatar
  end

  scope "/", BusiApiWeb do
    pipe_through :browser
    get "/", DefaultController, :index
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: BusiApiWeb.Telemetry
    end
  end
end
