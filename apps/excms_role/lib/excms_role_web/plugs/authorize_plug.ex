defmodule ExcmsRoleWeb.AuthorizePlug do
  import Plug.Conn
  alias ExcmsRole.UsersRolesService

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :permissions, get_permissions(conn))
  end

  defp get_permissions(%{assigns: %{current_user: %{id: id}}}),
    do: UsersRolesService.get_permissions(id)

  defp get_permissions(_conn), do: []
end
