defmodule ExcmsRole.RolesService.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExcmsCore.Warehouse
  alias ExcmsRole.RolesService.PermissionAction
  alias ExcmsRole.RolesService.PermissionResource

  schema "roles" do
    field :name, :string
    embeds_many :permission_resources, PermissionResource, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> cast_embed(:permission_resources)
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> put_all_permissions()
  end

  def get_permission_map(permission_resources) do
    permission_resources
    |> Enum.map(fn x ->
      permission_actions =
        x.permission_actions
        |> Enum.map(fn y -> {y.name, y.access_level} end)
        |> Map.new()

      {x.name, permission_actions}
    end)
    |> Map.new()
  end

  def get_access_level(permission_map, resource_name, action) do
    permission_map
    |> Map.get(resource_name, %{})
    |> Map.get(action, "no")
  end

  defp put_all_permissions(changeset) do
    current_permissions =
      changeset
      |> get_field(:permission_resources, [])
      |> get_permission_map()

    resources =
      for resource <- Warehouse.resources() do
        helpers = Warehouse.resource_to_helpers(resource)
        resource_name = helpers.name()

        actions =
          for action <- helpers.actions() do
            current_access_level = get_access_level(current_permissions, resource_name, action)

            %PermissionAction{
              name: action,
              access_level: current_access_level,
              access_level_options: helpers.access_levels(action)
            }
          end

        %PermissionResource{name: resource_name, permission_actions: actions}
      end

    put_embed(changeset, :permission_resources, resources)
  end

  defmodule Helpers do
    use ExcmsCore.EctoResourceHelpers
  end
end
