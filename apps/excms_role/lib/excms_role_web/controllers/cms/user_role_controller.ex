defmodule ExcmsRoleWeb.Cms.UserRoleController do
  use ExcmsRoleWeb, :controller

  alias ExcmsAccount.UsersService.User
  alias ExcmsRole.UsersRolesService
  alias ExcmsRole.UsersRolesService.UserRole
  alias ExcmsRole.RolesService
  alias ExcmsRole.RolesService.Role
  alias ExcmsCore.CmsAccess

  plug :load_roles

  @page_size 50

  def permissions(type), do: [{type, UserRole}, {type, CmsAccess}, {:read, User}, {:read, Role}]

  def index(conn, params) do
    page = Map.get(params, "page", "1")
    |> String.to_integer()

    search = Map.get(params, "search")

    users = UsersRolesService.page_users(page, @page_size, search)

    users_count = UsersRolesService.count_users(search)
    page_max = div(users_count-1, @page_size) + 1

    render(conn, "index.html",
      users: users, search: search, page: page, page_max: page_max)
  end

  def show(conn, %{"id" => id}) do
    user = UsersRolesService.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = UsersRolesService.get_user!(id)
    changeset = UsersRolesService.change_user(user)

    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UsersRolesService.get_user!(id)

    case UsersRolesService.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User role updated successfully.")
        |> redirect(to: routes().cms_user_role_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{} = params) do
    update(conn, Map.put(params, "user", %{}))
  end

  defp load_roles(conn, _params) do
    assign(conn, :roles, RolesService.list_roles())
  end
end
