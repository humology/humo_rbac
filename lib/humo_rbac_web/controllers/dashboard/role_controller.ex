defmodule HumoRBACWeb.Dashboard.RoleController do
  use HumoRBACWeb, :controller

  alias HumoRBAC.RolesService
  alias HumoRBAC.RolesService.Role
  alias Humo.Warehouse
  alias HumoWeb.AuthorizationExtractor
  import HumoWeb, only: [routes: 0]

  plug :load_resources
  plug :assign_role when action in [:show, :edit, :update, :delete]

  use HumoWeb.AuthorizeControllerHelpers,
    resource_module: Role,
    resource_assign_key: :role

  def index(conn, _params) do
    authorization = AuthorizationExtractor.extract(conn)
    roles = RolesService.list_roles(authorization)
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
        |> redirect(to: routes().dashboard_role_path(conn, :show, role))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => _id}) do
    role = conn.assigns.role
    render(conn, "show.html", role: role)
  end

  def edit(conn, %{"id" => _id}) do
    role = conn.assigns.role
    changeset = RolesService.change_role(role)
    render(conn, "edit.html", role: role, changeset: changeset)
  end

  def update(conn, %{"id" => _id, "role" => role_params}) do
    role = conn.assigns.role

    case RolesService.update_role(role, role_params) do
      {:ok, role} ->
        conn
        |> put_flash(:info, "Role updated successfully.")
        |> redirect(to: routes().dashboard_role_path(conn, :show, role))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", role: role, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _id}) do
    role = conn.assigns.role
    {:ok, _role} = RolesService.delete_role(role)

    conn
    |> put_flash(:info, "Role deleted successfully.")
    |> redirect(to: routes().dashboard_role_path(conn, :index))
  end

  defp load_resources(conn, _params) do
    resources_helpers =
      Warehouse.resources()
      |> Enum.map(&Warehouse.resource_helpers/1)

    assign(conn, :resources_helpers, resources_helpers)
  end

  defp assign_role(conn, _opts) do
    role =
      Map.fetch!(conn.params, "id")
      |> RolesService.get_role!()
    assign(conn, :role, role)
  end
end
