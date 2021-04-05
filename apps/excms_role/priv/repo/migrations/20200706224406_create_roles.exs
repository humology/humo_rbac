defmodule ExcmsCore.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false
      add :create, {:array, :string}, default: [], null: false
      add :read, {:array, :string}, default: [], null: false
      add :update, {:array, :string}, default: [], null: false
      add :delete, {:array, :string}, default: [], null: false

      timestamps()
    end

    create unique_index(:roles, [:name])
  end
end
