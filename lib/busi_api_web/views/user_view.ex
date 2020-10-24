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

  def render("forgot_password.json", %{}) do
    %{status: true, message: "Your password resend email has been sent"}
  end

  def render("reset_password.json", %{}) do
    %{status: true, message: "Your password changed successfully"}
  end
end
