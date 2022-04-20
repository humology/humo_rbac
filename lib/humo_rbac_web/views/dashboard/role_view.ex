defmodule HumoRbacWeb.Dashboard.RoleView do
  use HumoRbacWeb, :view

  alias Humo.Warehouse

  def get_resources_map(role) do
    for resource <- role.resources, into: %{} do
      {resource.name, resource}
    end
  end

  def resource_actions_options(resource_name) do
    Warehouse.names_resources()
    |> Map.fetch!(resource_name)
    |> Warehouse.resource_helpers()
    |> apply(:actions, [])
  end
end
