defmodule BusiApiWeb.SessionController do
  use BusiApiWeb, :controller

  alias BusiApi.Accounts
  alias BusiApiWeb.Auth.Guardian

  action_fallback BusiApiWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Accounts.authenticate_by_email_and_password(email, password),
         {:ok, user, token} <- Guardian.create_token(user) do
      conn
      |> put_status(:created)
      |> put_view(BusiApiWeb.UserView)
      |> render("user.json", %{user: user, token: token})
    end
  end
end
