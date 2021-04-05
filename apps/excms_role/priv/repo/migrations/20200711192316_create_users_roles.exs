defmodule ExcmsCore.Repo.Migrations.CreateUsersRoles do
  use Ecto.Migration

  def change do
    create table(:users_roles) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :role_id, references(:roles, on_delete: :delete_all), null: false

      timestamps(updated_at: false)
    end

    create index(:users_roles, [:user_id])
    create index(:users_roles, [:role_id])
  end
end
