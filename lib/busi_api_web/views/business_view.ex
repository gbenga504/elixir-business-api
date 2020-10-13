defmodule BusiApiWeb.BusinessView do
  use BusiApiWeb, :view
  alias BusiApiWeb.BusinessView

  def render("index.json", %{businesses: businesses}) do
    %{
      total: businesses.total,
      total_pages: businesses.total_pages,
      page: businesses.page,
      page_size: businesses.page_size,
      data: render_many(businesses.entries, BusinessView, "business.json")
    }
  end

  def render("show.json", %{business: business}) do
    %{data: render_one(business, BusinessView, "business.json")}
  end

  def render("business.json", %{business: business}) do
    %{
      id: business.id,
      name: business.name,
      description: business.description,
      tag: business.tag,
      date: business.inserted_at
      # date: NaiveDateTime.to_string(business.inserted_at)
    }
  end
end
