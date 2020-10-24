defmodule BusiApiWeb.PasswordResetController do
  use BusiApiWeb, :controller

  alias BusiApi.{Accounts, Email, Mailer}

  action_fallback BusiApiWeb.FallbackController

  def create(conn, %{"email" => email}) do
    password_params = %{
      "password_reset_token" => SecureRandom.urlsafe_base64(),
      "password_reset_sent_at" => NaiveDateTime.utc_now()
    }

    with {:ok, user} <- Accounts.get_user_by(email: email),
         _user <- Accounts.update_password_reset_token!(user, password_params) do
      # send email here
      user
      |> Email.password_reset()
      |> Mailer.deliver_later()

      conn
      |> put_status(:created)
      |> put_view(BusiApiWeb.UserView)
      |> render("forgot_password.json", %{})
    end
  end

  def update(conn, %{"token" => token, "password" => password}) do
    password_params = %{
      "password_reset_token" => nil,
      "password_reset_sent_at" => nil,
      "password" => password
    }

    with {:ok, user} <- Accounts.get_user_by(password_reset_token: token),
         {:ok, true} <- Accounts.valid_password_reset_token?(user.password_reset_sent_at),
         _user <- Accounts.update_user!(user, password_params) do
      conn
      |> put_status(:created)
      |> put_view(BusiApiWeb.UserView)
      |> render("reset_password.json", %{})
    end
  end
end
