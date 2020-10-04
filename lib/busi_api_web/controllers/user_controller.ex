defmodule BusiApiWeb.UserController do
  use BusiApiWeb, :controller

  alias BusiApi.Accounts
  alias BusiApi.Accounts.User
  alias BusiApiWeb.Auth.Guardian

  action_fallback BusiApiWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, user, token} <- Guardian.create_token(user) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end
end
