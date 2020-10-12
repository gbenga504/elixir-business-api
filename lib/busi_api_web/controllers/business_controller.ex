defmodule BusiApiWeb.BusinessController do
  use BusiApiWeb, :controller

  alias BusiApi.Directory
  alias BusiApi.Directory.Business

  action_fallback BusiApiWeb.FallbackController

  def index(conn, _params, _current_user) do
    businesses = Directory.list_businesses()
    render(conn, "index.json", businesses: businesses)
  end

  def create(conn, business_params, current_user) do
    with {:ok, %Business{} = business} <- Directory.create_business(current_user, business_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.business_path(conn, :show, business))
      |> render("show.json", business: business)
    end
  end

  def show(conn, %{"id" => id}, _current_user) do
    business = Directory.get_business!(id)
    render(conn, "show.json", business: business)
  end

  def update(conn, business_params, _current_user) do
    business = Directory.get_business!(business_params["id"])

    with {:ok, %Business{} = business} <- Directory.update_business(business, business_params) do
      render(conn, "show.json", business: business)
    end
  end

  def delete(conn, %{"id" => id}, _current_user) do
    business = Directory.get_business!(id)

    with {:ok, %Business{}} <- Directory.delete_business(business) do
      send_resp(conn, :no_content, "")
    end
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
