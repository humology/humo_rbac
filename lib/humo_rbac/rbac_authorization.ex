defmodule HumoRBAC.RBACAuthorization do
  defstruct is_administrator: false,
            authorized_resource_actions: %{}

  def from_roles(roles) do
    if is_administrator?(roles) do
      %__MODULE__{is_administrator: true}
    else
      %__MODULE__{
        is_administrator: false,
        authorized_resource_actions: roles_to_authorization(roles)
      }
    end
  end

  defp roles_to_authorization(roles) do
    for role <- roles,
        resource <- role.resources,
        action <- resource.actions do
      %{resource_name: resource.name, action: action}
    end
    |> Enum.uniq()
    |> Enum.group_by(fn x -> x.resource_name end, fn x -> x.action end)
    |> Enum.into(%{})
  end

  defp is_administrator?(roles) do
    Enum.any?(roles, fn x -> x.name == "administrator" end)
  end
end
