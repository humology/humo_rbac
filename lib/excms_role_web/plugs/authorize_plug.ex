defmodule ExcmsRoleWeb.AuthorizePlug do
  import Plug.Conn
  alias ExcmsRole.UsersRolesService
  alias ExcmsRole.RBACAuthorization

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :authorization, get_authorization(conn))
  end

  defp get_authorization(%{assigns: %{current_user: %{id: user_id}}}) do
    user_id
    |> UsersRolesService.get_user!()
    |> Map.fetch!(:roles)
    |> RBACAuthorization.from_roles()
  end

  defp get_authorization(_conn), do: []
end
