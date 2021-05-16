defmodule ExcmsRoleWeb.Cms.RoleView do
  use ExcmsRoleWeb, :view
  alias ExcmsRole.RolesService.Role

  def resources_with_commas(resources) do
    resources
    |> Enum.sort()
    |> Enum.join(", ")
  end

  def get_access_level(permission_map, helpers, action) do
    Role.get_access_level(permission_map, helpers.name(), action)
  end

  def get_permission_map(role) do
    Role.get_permission_map(role.permission_resources)
  end
end
