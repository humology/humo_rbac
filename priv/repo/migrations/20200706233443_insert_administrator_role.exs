defmodule ExcmsCore.Repo.Migrations.InsertAdministratorRole do
  use Ecto.Migration

  def up do
    """
    insert into roles("name", "permission_resources", "inserted_at", "updated_at")
    values(
      'administrator',
      '[{"name": "global_access", "permission_actions": [{"name": "administrator", "access_level": "all"}]}]',
      now(),
      now()
    )
    """
    |> ExcmsCore.Repo.query()
  end

  def down do
    ExcmsCore.Repo.query("delete from roles where name='administrator'")
  end
end
