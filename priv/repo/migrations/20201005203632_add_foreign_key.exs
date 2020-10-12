defmodule BusiApi.Repo.Migrations.AddForeignKey do
  use Ecto.Migration

  def change do
    alter table(:businesses) do
      add :user_id, references(:users, type: :uuid)
    end
  end
end
