defmodule BusiApiWeb.Auth.Guardian do
  use Guardian, otp_app: :busi_api
  alias BusiApi.Accounts
  alias BusiApiWeb.Auth.Guardian.Plug

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_user!(id)
    {:ok, resource}
  end

  def login(conn, user) do
    conn
    |> Plug.sign_in(user)
    |> Plug.current_token()
  end

  def logout(conn) do
    Plug.sign_out(conn)
  end
end
