defmodule BusiApi.Repo.Migrations.AddTables do
  use Ecto.Migration

  def change do
    create table(:businesses, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :description, :text
      add :tag, :string

      timestamps()
    end

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string
      add :encrypted_password, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
