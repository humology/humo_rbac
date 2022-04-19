defmodule Humo.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:excms_role_roles) do
      add :name, :string, null: false
      add :resources, :jsonb, default: "[]", null: false

      timestamps()
    end

    create unique_index(:excms_role_roles, [:name])
  end
end
