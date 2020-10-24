defmodule BusiApi.Accounts.User do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_reset_token, :string
    field :password_reset_sent_at, :naive_datetime
    field :avatar, BusiApi.MediaUploader.Type

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_reset_token, :password_reset_sent_at])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  # This extra changeset is not needed if we update_change(changeset, :password, new_value)
  # but since we use password as a virtual field in the DB then it is necessary we do this
  def password_reset_changeset(user, attrs) do
    user
    |> cast(attrs, [:password_reset_token, :password_reset_sent_at])
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
