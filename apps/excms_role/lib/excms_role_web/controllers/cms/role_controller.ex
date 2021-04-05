defmodule ExcmsRoleWeb.Cms.RoleController do
  use ExcmsRoleWeb, :controller

  alias ExcmsRole.RolesService
  alias ExcmsRole.RolesService.Role
  alias ExcmsCore.CmsAccess
  alias ExcmsCoreWeb.Authorizer

  plug :load_resources

  def permissions(type), do: [{type, Role}, {type, CmsAccess}]

  def index(conn, _params) do
    roles = RolesService.list_roles()
    render(conn, "index.html", roles: roles)
  end

  def new(conn, _params) do
    changeset = RolesService.change_role(%Role{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"role" => role_params}) do
    case RolesService.create_role(role_params) do
      {:ok, role} ->
        conn
        |> put_flash(:info, "Role created successfully.")
        |> redirect(to: routes().cms_role_path(conn, :show, role))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    role = RolesService.get_role!(id)
    render(conn, "show.html", role: role)
  end

  def edit(conn, %{"id" => id}) do
    role = RolesService.get_role!(id)
    changeset = RolesService.change_role(role)
    render(conn, "edit.html", role: role, changeset: changeset)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = RolesService.get_role!(id)

    case RolesService.update_role(role, role_params) do
      {:ok, role} ->
        conn
        |> put_flash(:info, "Role updated successfully.")
        |> redirect(to: routes().cms_role_path(conn, :show, role))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", role: role, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = RolesService.get_role!(id)
    {:ok, _role} = RolesService.delete_role(role)

    conn
    |> put_flash(:info, "Role deleted successfully.")
    |> redirect(to: routes().cms_role_path(conn, :index))
  end

  defp load_resources(conn, _params) do
    assign(conn, :resources, Authorizer.list_resources())
  end
end
