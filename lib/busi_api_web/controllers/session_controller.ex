defmodule BusiApiWeb.SessionController do
  use BusiApiWeb, :controller

  alias BusiApi.Accounts
  alias BusiApiWeb.Auth.Guardian

  action_fallback BusiApiWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Accounts.authenticate_by_email_and_password(email, password),
         token <- Guardian.login(conn, user) do
      conn
      |> put_status(:created)
      |> put_view(BusiApiWeb.UserView)
      |> render("user.json", %{user: user, token: token})
    end
  end

  def delete(conn, _) do
    conn
    |> put_status(:created)
    |> Guardian.logout()
    |> send_resp(:no_content, "")
  end
end
