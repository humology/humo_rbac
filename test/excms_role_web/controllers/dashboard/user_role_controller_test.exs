defmodule ExcmsRoleWeb.Dashboard.UserRoleControllerTest do
  use ExcmsRoleWeb.ConnCase, async: true

  alias ExcmsRole.UsersRolesService
  alias ExcmsRole.UsersRolesService.User
  alias ExcmsRole.RolesService.Role
  alias Humo.Authorizer.{Mock, AllAccess, NoAccess}

  setup do
    role = insert(:role)
    user = insert(:user)

    %{role: role, user: user}
  end

  describe "index" do
    test "render allowed links", %{conn: conn, user: user} do
      for resource_can_actions <- [[], ["read"], ["update"], ["read", "update"]] do
        fn ->
          conn = get(conn, routes().dashboard_user_role_path(conn, :index))

          response = html_response(conn, 200)
          assert response =~ "<h3>Users roles</h3>"
          assert response =~ user.first_name
          assert response =~ user.last_name
          assert (response =~ "Show") == ("read" in resource_can_actions)
          assert (response =~ "Edit") == ("update" in resource_can_actions)
        end
        |> Mock.with_mock(
          can_all: fn _, "read", User -> User end,
          can_actions: fn
            _, %User{} -> resource_can_actions
            _, {:list, User} -> ["read"]
            _, {:list, Role} -> ["read"]
            _, _ -> []
          end
        )
      end
    end

    test "when list of record is empty, renders no user", %{conn: conn, user: user} do
      fn ->
        conn = get(conn, routes().dashboard_user_role_path(conn, :index))

        response = html_response(conn, 200)
        assert response =~ "<h3>Users roles</h3>"
        refute response =~ user.first_name
        refute response =~ user.last_name
        refute response =~ "Show"
        refute response =~ "Edit"
        refute response =~ "Delete"
      end
      |> Mock.with_mock(
        can_all: fn _, "read", User -> Humo.Repo.none(User) end,
        can_actions: &AllAccess.can_actions/2
      )
    end

    test "no access", %{conn: conn} do
      fn ->
        conn = get(conn, routes().dashboard_user_role_path(conn, :index))

        assert response(conn, 403) =~ "Forbidden"
      end
      |> Mock.with_mock(can_actions: &NoAccess.can_actions/2)
    end
  end

  describe "show" do
    test "renders show available actions", %{conn: conn, user: user} do
      for record_can_actions <- [["read", "update"], ["read"]],
          list_module_can_actions <- [["read"], []] do
        fn ->
          conn = get(conn, routes().dashboard_user_role_path(conn, :show, user))

          response = html_response(conn, 200)
          assert (response =~ "Edit") == ("update" in record_can_actions)
          assert (response =~ "Back") == ("read" in list_module_can_actions)
        end
        |> Mock.with_mock(can_actions: fn
          _, %User{} -> record_can_actions
          _, {:list, User} -> list_module_can_actions
          _, {:list, Role} -> ["read"]
          _, _ -> []
        end)
      end
    end

    test "no access", %{conn: conn, user: user} do
      fn ->
        conn = get(conn, routes().dashboard_user_role_path(conn, :show, user))

        assert response(conn, 403) =~ "Forbidden"
      end
      |> Mock.with_mock(can_actions: &NoAccess.can_actions/2)
    end
  end

  describe "edit user roles" do
    test "renders user edit form with allowed links", %{conn: conn, user: user} do
      for list_module_can_actions <- [["read"], []] do
        fn ->
          conn = get(conn, routes().dashboard_user_role_path(conn, :edit, user))

          response = html_response(conn, 200)
          assert response =~ "<h3>Edit User roles</h3>"
          assert (response =~ "Back") == ("read" in list_module_can_actions)
        end
        |> Mock.with_mock(
          can_all: fn _, "read", Role -> Role end,
          can_actions: fn
            _, %User{} -> ["update"]
            _, {:list, User} -> list_module_can_actions
            _, {:list, Role} -> ["read"]
            _, _ -> []
          end
        )
      end
    end

    test "no access", %{conn: conn, user: user} do
      fn ->
        conn = get(conn, routes().dashboard_user_role_path(conn, :edit, user))
        assert response(conn, 403) =~ "Forbidden"
      end
      |> Mock.with_mock(can_actions: &NoAccess.can_actions/2)
    end
  end

  describe "update user roles" do
    test "redirects when data is valid", %{conn: conn, user: user, role: role} do
      fn ->
        conn = put(conn, routes().dashboard_user_role_path(conn, :update, user), user: %{roles: [role.id]})
        assert redirected_to(conn) == routes().dashboard_user_role_path(conn, :show, user)

        user = UsersRolesService.get_user!(user.id)
        assert [role] == user.roles
      end
      |> Mock.with_mock(can_actions: fn
        _, %User{} -> ["update"]
        _, {:list, Role} -> ["read"]
      end)
    end

    test "no access", %{conn: conn, user: user, role: role} do
      fn ->
        conn = put(conn, routes().dashboard_user_role_path(conn, :update, user), user: %{roles: [role.id]})
        assert response(conn, 403) =~ "Forbidden"
      end
      |> Mock.with_mock(can_actions: &NoAccess.can_actions/2)
    end
  end
end
