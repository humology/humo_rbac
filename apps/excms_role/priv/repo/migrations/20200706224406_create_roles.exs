defmodule ExcmsCore.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false
      add :permission_resources, :jsonb, default: "[]", null: false

      timestamps()
    end

    create unique_index(:roles, [:name])
  end
end
