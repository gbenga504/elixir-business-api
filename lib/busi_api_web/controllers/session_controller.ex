defmodule BusiApiWeb.SessionController do
  use BusiApiWeb, :controller

  alias BusiApi.Accounts
  alias BusiApiWeb.Auth.Plug

  action_fallback BusiApiWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Accounts.authenticate_by_email_and_password(email, password),
         {conn, token} <- Plug.login(conn, user) do
      conn
      |> put_status(:created)
      |> put_view(BusiApiWeb.UserView)
      |> render("user.json", %{user: user, token: token})
    end
  end

  def update(conn, %{}) do
    with {:ok, {conn, token}} <- Plug.refresh_token(conn) do
      conn
      |> put_status(:created)
      |> put_view(BusiApiWeb.UserView)
      |> render("user.json", %{user: conn.assigns.current_user, token: token})
    end
  end

  def delete(conn, _) do
    conn
    |> Plug.logout()
    |> put_status(:created)
    |> send_resp(:no_content, "")
  end
end
