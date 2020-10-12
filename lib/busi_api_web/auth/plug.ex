defmodule BusiApiWeb.Auth.Plug do
  import Plug.Conn
  import Guardian
  alias BusiApiWeb.Auth.Guardian
  alias BusiApiWeb.Auth.ErrorHandler

  def init(opts), do: opts

  def call(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user, %{}, ttl: {5, :minutes})
    |> fetch_session()
    |> assign(:current_user, user)
    |> Guardian.Plug.remember_me(
      user,
      %{"typ" => "refresh"},
      ttl: {30, :days}
    )
    |> return_conn_token()
  end

  def logout(conn) do
    conn
    |> Guardian.Plug.sign_out()
    |> Guardian.Plug.clear_remember_me()
    |> fetch_session()
    |> configure_session(drop: true)
  end

  def refresh_token(conn) do
    case get_refresh_token_cookies(conn) do
      nil ->
        {:error, :unauthorized}

      token ->
        handle_refresh_token_if_found(conn, Guardian.resource_from_token(token))
    end
  end

  def verify_cookie_refresh_token(conn, _opts) do
    case get_refresh_token_cookies(conn) do
      nil ->
        ErrorHandler.auth_error(conn, {:unauthorized, "Missing refresh token"}, [])

      token ->
        case Guardian.decode_and_verify(token, %{"typ" => "refresh"}) do
          {:ok, _claims} ->
            conn

          {:error, _reason} ->
            ErrorHandler.auth_error(conn, {:unauthorized, "Refresh token not stable"}, [])
        end
    end
  end

  defp return_conn_token(conn) do
    token = Guardian.Plug.current_token(conn)
    conn = configure_session(conn, renew: true)
    {conn, token}
  end

  defp get_refresh_token_cookies(conn) do
    conn_params = fetch_cookies(conn)
    Map.get(conn_params.cookies, "guardian_default_token")
  end

  defp handle_refresh_token_if_found(conn, {:ok, resource, claims}) do
    current_time = timestamp()

    cond do
      current_time > claims["exp"] ->
        {:error, :unauthorized}

      current_time <= claims["exp"] && is_nil(resource) == false ->
        {:ok, login(conn, resource)}
    end
  end

  defp handle_refresh_token_if_found(_conn, {:error, _reason}) do
    {:error, :unauthorized}
  end
end
