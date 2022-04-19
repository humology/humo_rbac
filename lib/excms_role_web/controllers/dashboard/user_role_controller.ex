defmodule ExcmsRoleWeb.Dashboard.UserRoleController do
  use ExcmsRoleWeb, :controller

  alias ExcmsRole.UsersRolesService
  alias ExcmsRole.UsersRolesService.User
  alias ExcmsRole.RolesService
  alias ExcmsRole.RolesService.Role
  alias HumoWeb.AuthorizationExtractor
  import HumoWeb, only: [routes: 0]

  @page_size 50

  plug :assign_user when action in [:show, :edit, :update, :delete]

  use HumoWeb.AuthorizeControllerHelpers,
    resource_module: User,
    resource_assign_key: :user

  def required_permissions(phoenix_action, assigns) do
    [
      {"read", {:list, Role}},
      required_rest_permissions(phoenix_action, assigns)
    ]
  end

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    search = Map.get(params, "search")

    authorization = AuthorizationExtractor.extract(conn)

    users = UsersRolesService.page_users(authorization, page, @page_size, search)

    users_count = UsersRolesService.count_users(authorization, search)
    page_max = div(users_count - 1, @page_size) + 1

    render(
      conn,
      "index.html",
      users: users, search: search, page: page, page_max: page_max
    )
  end

  def show(conn, _params) do
    user = conn.assigns.user
    render(conn, "show.html", user: user)
  end

  def edit(conn, _params) do
    user = conn.assigns.user
    changeset = UsersRolesService.change_user(user)

    authorization = AuthorizationExtractor.extract(conn)
    roles = RolesService.list_roles(authorization)

    render(conn, "edit.html", user: user, changeset: changeset, roles: roles)
  end

  def update(conn, params) do
    user_params = Map.get(params, "user", %{})
    user = conn.assigns.user

    case UsersRolesService.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User roles updated successfully.")
        |> redirect(to: routes().dashboard_user_role_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  defp assign_user(conn, _opts) do
    user_id = Map.fetch!(conn.params, "id")
    assign(conn, :user, UsersRolesService.get_user!(user_id))
  end
end
