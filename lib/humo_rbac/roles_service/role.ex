defmodule HumoRbac.RolesService.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Humo.Warehouse
  alias HumoRbac.RolesService.Resource

  schema "humo_rbac_roles" do
    field :name, :string
    embeds_many :resources, Resource, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> cast_embed(:resources)
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> put_all_resources()
  end

  defp put_all_resources(changeset) do
    changeset_resources = get_field(changeset, :resources, [])

    resources =
      for resource <- Warehouse.resources() do
        helpers = Warehouse.resource_helpers(resource)
        resource_name = helpers.name()

        changeset_resources
        |> Enum.find(
          %Resource{name: resource_name, actions: []},
          fn changeset_resource ->
            changeset_resource.name == resource_name
          end
        )
      end

    put_embed(changeset, :resources, resources)
  end

  defmodule Helpers do
    use Humo.EctoResourceHelpers
  end
end
