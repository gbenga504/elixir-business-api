defmodule BusiApi.Directory.Business do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "businesses" do
    field :description, :string
    field :name, :string
    field :tag, :string
    belongs_to :user, BusiApi.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(business, attrs) do
    business
    |> cast(attrs, [:name, :description, :tag])
    |> validate_required([:name, :description, :tag])
  end
end
