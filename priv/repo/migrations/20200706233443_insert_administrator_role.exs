defmodule Humo.Repo.Migrations.InsertAdministratorRole do
  use Ecto.Migration

  def up do
    """
    insert into excms_role_roles("name", "resources", "inserted_at", "updated_at")
    values('administrator', '[]', now(), now())
    """
    |> Humo.Repo.query()
  end

  def down do
    Humo.Repo.query("delete from excms_role_roles where name='administrator'")
  end
end
