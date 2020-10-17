defmodule BusiApiWeb.UserController do
  use BusiApiWeb, :controller

  alias BusiApi.Accounts
  alias BusiApi.Accounts.User
  alias BusiApiWeb.Auth.Plug

  action_fallback BusiApiWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {conn, token} <- Plug.login(conn, user) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end

  def update_avatar(conn, %{"avatar" => file}) do
    with user <- conn.assigns.current_user,
         {:ok, %User{} = user} <- Accounts.update_user_avatar(user, %{"avatar" => file}) do
      avatar = BusiApi.MediaUploader.url({user.avatar, user}, :thumb)

      conn
      |> put_status(:created)
      |> render("avatar.json", %{avatar: avatar})
    end
  end

  def delete_avatar(conn, _) do
    with user <- conn.assigns.current_user,
         :ok <- BusiApi.MediaUploader.delete({user.avatar, user}),
         {:ok, %User{} = _user} <- Accounts.update_user_avatar(user, %{"avatar" => nil}) do

      conn
      |> put_status(:created)
      |> render("avatar.json", %{avatar: nil})
    end
  end
end
