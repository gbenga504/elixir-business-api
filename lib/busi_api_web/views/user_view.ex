defmodule BusiApiWeb.UserView do
  use BusiApiWeb, :view

  def render("user.json", %{user: user, token: token}) do
    %{email: user.email, token: token}
  end

  def render("avatar.json", %{avatar: nil}) do
    %{avatar: nil}
  end

  def render("avatar.json", %{avatar: avatar}) do
    %{avatar: "#{System.get_env("BASE_URL")}#{avatar}"}
  end
end
