defmodule BusiApi.Repo.Migrations.DropTables do
  use Ecto.Migration

  def change do
    drop table("users")
    drop table("businesses")
  end
end
