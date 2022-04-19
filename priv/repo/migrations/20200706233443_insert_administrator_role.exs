defmodule Humo.Repo.Migrations.InsertAdministratorRole do
  use Ecto.Migration

  def up do
    """
    insert into humo_rbac_roles("name", "resources", "inserted_at", "updated_at")
    values('administrator', '[]', now(), now())
    """
    |> Humo.Repo.query()
  end

  def down do
    Humo.Repo.query("delete from humo_rbac_roles where name='administrator'")
  end
end
