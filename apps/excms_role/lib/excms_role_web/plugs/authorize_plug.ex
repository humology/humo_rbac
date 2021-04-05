defmodule ExcmsRoleWeb.AuthorizePlug do
  import Plug.Conn
  alias ExcmsCoreWeb.Authorizer.Authorization
  alias ExcmsRole.UsersRolesService

  def init(opts), do: opts

  def call(conn, _opts) do
    authorization = conn
    |> get_roles()
    |> from_roles()

    assign(conn, :authorization, authorization)
  end

  defp get_roles(%{assigns: %{current_user: %{id: id}}}), do: UsersRolesService.get_user!(id).roles
  defp get_roles(_conn), do: []

  defp from_roles(roles) when is_list(roles) do
    roles
    |> Enum.map(&from_role/1)
    |> Authorization.join()
  end

  defp from_role(role) do
    permissions = role
    |> parse_role_permissions()
    |> MapSet.new()

    %Authorization{
      is_administrator: is_administrator(role),
      permissions: permissions
    }
  end

  defp parse_role_permissions(role) do
    [:create, :read, :update, :delete]
    |> Enum.flat_map(fn action ->
      Map.fetch!(role, action)
      |> Enum.map(&({action, &1}))
    end)
  end

  defp is_administrator(%{name: name}), do: name == "administrator"
end
