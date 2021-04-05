defmodule ExcmsRole.RolesService.Role do
  use Ecto.Schema
  use ExcmsCore.Resource
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :create, {:array, :string}
    field :read, {:array, :string}
    field :update, {:array, :string}
    field :delete, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :create, :read, :update, :delete])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
