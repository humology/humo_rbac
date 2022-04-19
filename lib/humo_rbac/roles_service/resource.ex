defmodule HumoRBAC.RolesService.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :actions, {:array, :string}
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :actions])
    |> validate_required([:name])
  end
end
