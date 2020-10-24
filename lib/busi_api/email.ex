defmodule BusiApi.Email do
  use Bamboo.Phoenix, view: BusiApiWeb.EmailView

  def password_reset(user) do
    base_email()
    |> to(user.email)
    |> subject("Password reset")
    |> put_html_layout({BusiApiWeb.LayoutView, "email.html"})
    |> assign(:user, user)
    |> render("password_reset.html")
  end

  def base_email do
    new_email()
    |> from("busiapi@example.com")
  end
end
