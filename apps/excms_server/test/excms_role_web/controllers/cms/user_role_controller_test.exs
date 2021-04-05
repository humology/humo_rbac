defmodule ExcmsRoleWeb.Cms.UserRoleControllerTest do
  use ExcmsServer.ConnCase

  alias ExcmsRole.UsersRolesService
  alias ExcmsRole.RolesService

  setup %{conn: conn} do
    user = insert(:admin_user)

    conn = conn
    |> Plug.Test.init_test_session(user_id: user.id)

    %{conn: conn}
  end

  describe "index" do
    test "lists all users_roles", %{conn: conn} do
      conn = get(conn, routes().cms_user_role_path(conn, :index))
      assert html_response(conn, 200) =~ "<h3>Users roles</h3>"
    end
  end

  describe "edit user_role" do
    setup do
      %{user: insert(:readonly_user)}
    end

    test "renders form for editing user roles", %{conn: conn, user: user} do
      conn = get(conn, routes().cms_user_role_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User role"

      assert [%{name: "readonly"}] = UsersRolesService.get_user!(user.id).roles
    end
  end

  describe "update user_role" do
    setup do
      %{user: insert(:readonly_user)}
    end

    test "redirects when data is valid", %{conn: conn, user: user} do
      [admin_role] = RolesService.list_roles()
      |> Enum.filter(&(&1.name == "administrator"))

      conn = put(conn,
        routes().cms_user_role_path(conn, :update, user.id),
        user: %{roles: [admin_role.id]})
      assert redirected_to(conn) == routes().cms_user_role_path(conn, :show, user)

      assert [%{name: "administrator"}] =
               UsersRolesService.get_user!(user.id).roles
    end
  end
end
