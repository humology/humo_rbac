defmodule ExcmsRole.RolesServiceTest do
  use ExcmsRole.DataCase

  alias ExcmsRole.RolesService

  describe "roles" do
    alias ExcmsRole.RolesService.Role

    @valid_attrs %{name: "some name", permission_resources: []}
    @update_attrs %{name: "some updated name", permission_resources: []}
    @invalid_attrs %{name: nil, permission_resources: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> RolesService.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()

      roles_except_admin =
        RolesService.list_roles()
        |> Enum.reject(&(&1.name == "administrator"))

      assert Enum.map(roles_except_admin, &cleanup/1) == Enum.map([role], &cleanup/1)
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert cleanup(RolesService.get_role!(role.id)) == cleanup(role)
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = RolesService.create_role(@valid_attrs)
      assert role.name == "some name"
      assert cleanup(role) == []
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RolesService.create_role(@invalid_attrs)
    end

    test "create_role/1 with duplicate rolename" do
      assert {:ok, %Role{} = role} = RolesService.create_role(@valid_attrs)
      assert role.name == "some name"
      assert cleanup(role) == []

      assert {:error, %Ecto.Changeset{}} = RolesService.create_role(@valid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, %Role{} = role} = RolesService.update_role(role, @update_attrs)
      assert role.name == "some updated name"
      assert cleanup(role) == []
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = RolesService.update_role(role, @invalid_attrs)
      assert cleanup(RolesService.get_role!(role.id)) == cleanup(role)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = RolesService.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> RolesService.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = RolesService.change_role(role)
    end
  end

  defp cleanup(role) do
    role.permission_resources
    |> Enum.map(fn resource ->
      actions =
        resource.permission_actions
        |> Enum.reject(fn x -> x.access_level == "no" end)
        |> Enum.map(&%{&1 | access_level_options: nil})

      %{resource | permission_actions: actions}
    end)
    |> Enum.reject(fn x -> x.permission_actions == [] end)
  end
end
