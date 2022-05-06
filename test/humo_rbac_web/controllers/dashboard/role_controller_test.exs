defmodule HumoRbacWeb.Dashboard.RoleControllerTest do
  use HumoRbacWeb.ConnCase, async: true

  alias HumoRbac.RolesService
  alias HumoRbac.RolesService.Role
  alias Humo.Authorizer.{Mock, AllAccess, NoAccess}

  @create_attrs %{
    name: "some name",
    resources: [%{name: "humo_rbac_roles", actions: ["update"]}]
  }
  @update_attrs %{
    name: "some updated name",
    resources: [%{name: "humo_rbac_roles", actions: ["read", "delete"]}]
  }
  @invalid_attrs %{name: nil, resources: nil}

  describe "index" do
    setup [:create_role]

    test "render allowed links", %{conn: conn} do
      for resource_can_actions <- [[], ["read"], ["update"], ["delete"], ["read", "update", "delete"]],
          resource_module_can_actions <- [[], ["create"]] do
        fn ->
          conn = get(conn, routes().dashboard_humo_rbac_role_path(conn, :index))

          response = html_response(conn, 200)
          assert response =~ "<h3>Roles</h3>"
          assert response =~ @create_attrs.name
          assert (response =~ "Show") == ("read" in resource_can_actions)
          assert (response =~ "Edit") == ("update" in resource_can_actions)
          assert (response =~ "Delete") == ("delete" in resource_can_actions)
          assert (response =~ "New Role") == ("create" in resource_module_can_actions)
        end
        |> Mock.with_mock(
          can_all: fn _, "read", Role -> Role end,
          can_actions: fn
            _, Role -> resource_module_can_actions
            _, %Role{} -> resource_can_actions
            _, {:list, Role} -> ["read"]
            _, _ -> []
          end
        )
      end
    end

    test "when list of record is empty, renders no role", %{conn: conn} do
      fn ->
        conn = get(conn, routes().dashboard_humo_rbac_role_path(conn, :index))

        response = html_response(conn, 200)
        assert response =~ "<h3>Roles</h3>"
        refute response =~ @create_attrs.name
        refute response =~ "Show"
        refute response =~ "Edit"
        refute response =~ "Delete"

      end
      |> Mock.with_mock(
        can_all: fn _, "read", Role -> Humo.Repo.none(Role) end,
        can_actions: &AllAccess.can_actions/2
      )
    end

    test "no access", %{conn: conn} do
      fn ->
        conn = get(conn, routes().dashboard_humo_rbac_role_path(conn, :index))

        assert response(conn, 403) =~ "Forbidden"
      end
      |> Mock.with_mock(can_actions: &NoAccess.can_actions/2)
    end
  end

  describe "new role" do
    test "renders edit form with allowed links", %{conn: conn} do
      for list_module_can_actions <- [["read"], []] do
        fn ->
          conn = get(conn, routes().dashboard_humo_rbac_role_path(conn, :new))

          response = html_response(conn, 200)
          assert response =~ "New Role"
          assert (response =~ "Back") == ("read" in list_module_can_actions)
        end
        |> Mock.with_mock(can_actions: fn
          _, Role -> ["create"]
          _, {:list, Role} -> list_module_can_actions
          _, _ -> []
        end)
      end
    end

    test "no access", %{conn: conn} do
      fn ->
        conn = get(conn, routes().dashboard_humo_rbac_role_path(conn, :new))

        assert response(conn, 403) =~ "Forbidden"
      end
      |> Mock.with_mock(can_actions: &NoAccess.can_actions/2)
    end
  end

  describe "create role" do
    test "redirects when data is valid", %{conn: conn} do
      fn ->
        conn = post(conn, routes().dashboard_humo_rbac_role_path(conn, :create), role: @create_attrs)

        assert %{id: id} = redirected_params(conn)
        assert redirected_to(conn) == routes().dashboard_humo_rbac_role_path(conn, :show, id)

        role = RolesService.get_role!(id)
        assert "some name" = role.name
        assert %{actions: ["update"]} =
          Enum.find(role.resources, &(&1.name == "humo_rbac_roles"))
      end
      |> Mock.with_mock(can_actions: fn
        _, Role -> ["create"]
        _, _ -> []
      end)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      fn ->
        conn = post(conn, routes().dashboard_humo_rbac_role_path(conn, :create), role: @invalid_attrs)

        assert html_response(conn, 200) =~ "New Role"
      end
      |> Mock.with_mock(can_actions: &AllAccess.can_actions/2)
    end

    test "no access", %{conn: conn} do
      fn ->
        conn = post(conn, routes().dashboard_humo_rbac_role_path(conn, :create), role: @create_attrs)
        assert response(conn, 403) =~ "Forbidden"
      end
      |> Mock.with_mock(can_actions: &NoAccess.can_actions/2)
    end
  end

  describe "edit role" do
    setup [:create_role]

    test "renders edit form with allowed links", %{conn: conn, role: role} do
      for list_module_can_actions <- [["read"], []] do
        fn ->
          conn = get(conn, routes().dashboard_humo_rbac_role_path(conn, :edit, role))

          response = html_response(conn, 200)
          assert response =~ "Edit Role"
          assert (response =~ "Back") == ("read" in list_module_can_actions)
        end
        |> Mock.with_mock(can_actions: fn
          _, %Role{} -> ["update"]
          _, {:list, Role} -> list_module_can_actions
          _, _ -> []
        end)
      end
    end

    test "no access", %{conn: conn, role: role} do
      fn ->
        conn = get(conn, routes().dashboard_humo_rbac_role_path(conn, :edit, role))

        assert response(conn, 403) =~ "Forbidden"
      end
      |> Mock.with_mock(can_actions: &NoAccess.can_actions/2)
    end
  end

  describe "update role" do
    setup [:create_role]

    test "redirects when data is valid", %{conn: conn, role: role} do
      fn ->
        conn = put(conn, routes().dashboard_humo_rbac_role_path(conn, :update, role), role: @update_attrs)

        assert redirected_to(conn) == routes().dashboard_humo_rbac_role_path(conn, :show, role)

        role = RolesService.get_role!(role.id)

        assert "some updated name" = role.name
        assert %{actions: ["read", "delete"]} =
          Enum.find(role.resources, &(&1.name == "humo_rbac_roles"))
      end
      |> Mock.with_mock(can_actions: fn
        _, %Role{} -> ["update"]
        _, _ -> []
      end)
    end

    test "renders errors when data is invalid", %{conn: conn, role: role} do
      fn ->
        conn = put(conn, routes().dashboard_humo_rbac_role_path(conn, :update, role), role: @invalid_attrs)

        assert html_response(conn, 200) =~ "Edit Role"
      end
      |> Mock.with_mock(can_actions: &AllAccess.can_actions/2)
    end

    test "no access", %{conn: conn, role: role} do
      fn ->
        conn = put(conn, routes().dashboard_humo_rbac_role_path(conn, :update, role), role: @update_attrs)

        assert response(conn, 403) =~ "Forbidden"
      end
      |> Mock.with_mock(can_actions: &NoAccess.can_actions/2)
    end
  end

  describe "show" do
    setup [:create_role]

    test "renders show available actions", %{conn: conn, role: role} do
      for record_can_actions <- [["read", "update"], ["read"]],
          list_module_can_actions <- [["read"], []] do
        fn ->
          conn = get(conn, routes().dashboard_humo_rbac_role_path(conn, :show, role))
          assert (html_response(conn, 200) =~ "Edit") == ("update" in record_can_actions)
          assert (html_response(conn, 200) =~ "Back") == ("read" in list_module_can_actions)
        end
        |> Mock.with_mock(can_actions: fn
          _, %Role{} -> record_can_actions
          _, {:list, Role} -> list_module_can_actions
          _, _ -> []
        end)
      end
    end

    test "no access", %{conn: conn, role: role} do
      fn ->
        conn = get(conn, routes().dashboard_humo_rbac_role_path(conn, :show, role))
        assert response(conn, 403) =~ "Forbidden"
      end
      |> Mock.with_mock(can_actions: &NoAccess.can_actions/2)
    end
  end

  describe "delete role" do
    setup [:create_role]

    test "deletes chosen role", %{conn: conn, role: role} do
      fn ->
        conn = delete(conn, routes().dashboard_humo_rbac_role_path(conn, :delete, role))
        assert redirected_to(conn) == routes().dashboard_humo_rbac_role_path(conn, :index)

        assert_error_sent 404, fn ->
          get(conn, routes().dashboard_humo_rbac_role_path(conn, :show, role))
        end
      end
      |> Mock.with_mock(can_actions: fn _, %Role{} -> ["delete"] end)
    end

    test "no access", %{conn: conn, role: role} do
      fn ->
        conn = delete(conn, routes().dashboard_humo_rbac_role_path(conn, :delete, role))
        assert response(conn, 403) =~ "Forbidden"
      end
      |> Mock.with_mock(can_actions: &NoAccess.can_actions/2)
    end
  end

  defp create_role(_) do
    {:ok, role} = RolesService.create_role(@create_attrs)
    %{role: role}
  end
end
