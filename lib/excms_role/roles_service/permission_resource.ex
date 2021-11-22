defmodule ExcmsRole.RolesService.PermissionResource do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExcmsRole.RolesService.PermissionAction

  @primary_key false
  embedded_schema do
    field :name, :string
    embeds_many :permission_actions, PermissionAction
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> cast_embed(:permission_actions)
    |> validate_required([:name])
  end
end
