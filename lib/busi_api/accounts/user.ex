defmodule BusiApi.Accounts.User do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :avatar, BusiApi.MediaUploader.Type

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  def avatar_changeset(user, %{"avatar" => nil}) do
    attrs = %{"avatar" => nil}
    user
    |> cast(attrs, [:avatar])
  end

  def avatar_changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> cast_attachments(attrs, [:avatar])
    |> validate_required([:avatar])
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :encrypted_password, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
