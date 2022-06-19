defmodule Humo.Repo.Migrations.CreateUsersRoles do
  use Ecto.Migration

  def change do
    create table(:humo_rbac_users_roles) do
      add :user_id, references(:humo_account_users, type: :binary_id, on_delete: :delete_all),
        null: false

      add :role_id, references(:humo_rbac_roles, on_delete: :delete_all), null: false

      timestamps(updated_at: false)
    end

    create index(:humo_rbac_users_roles, [:user_id])
    create index(:humo_rbac_users_roles, [:role_id])
  end
end
