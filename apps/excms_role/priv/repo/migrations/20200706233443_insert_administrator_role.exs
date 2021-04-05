defmodule ExcmsCore.Repo.Migrations.InsertAdministratorRole do
  use Ecto.Migration

  def change do
    """
    INSERT INTO roles(\"name\", \"create\", \"read\", \"update\",
      \"delete\", \"inserted_at\", \"updated_at\")
    VALUES('administrator', array[]::text[], array[]::text[],
      array[]::text[], array[]::text[], now(), now())
    """
    |> ExcmsCore.Repo.query()
  end
end
