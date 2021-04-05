defmodule ExcmsRoleWeb.Cms.RoleView do
  use ExcmsRoleWeb, :view

  def resources_with_commas(resources) do
    resources
    |> Enum.sort()
    |> Enum.join(", ")
  end
end
