defmodule Humo.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:humo_rbac_roles) do
      add :name, :string, null: false
      add :resources, :jsonb, default: "[]", null: false

      timestamps()
    end

    create unique_index(:humo_rbac_roles, [:name])
  end
end
