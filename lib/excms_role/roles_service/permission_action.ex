defmodule ExcmsRole.RolesService.PermissionAction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :access_level, :string
    field :access_level_options, :any, virtual: true
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :access_level])
    |> validate_required([:name, :access_level])
  end
end
