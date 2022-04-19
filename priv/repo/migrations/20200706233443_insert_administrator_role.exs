defmodule ExcmsCore.Repo.Migrations.InsertAdministratorRole do
  use Ecto.Migration

  def up do
    """
    insert into excms_role_roles("name", "resources", "inserted_at", "updated_at")
    values('administrator', '[]', now(), now())
    """
    |> ExcmsCore.Repo.query()
  end

  def down do
    ExcmsCore.Repo.query("delete from excms_role_roles where name='administrator'")
  end
end
