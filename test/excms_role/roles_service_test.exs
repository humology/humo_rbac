defmodule HumoRBAC.RolesServiceTest do
  use HumoRBAC.DataCase, async: true

  alias HumoRBAC.RolesService
  alias HumoRBAC.RolesService.Role
  alias HumoRBAC.RolesService.Resource
  alias Humo.Authorizer.Mock
  alias Humo.Authorizer.AllAccess
  alias Humo.Authorizer.NoAccess

  @valid_attrs %{name: "some name", resources: []}
  @update_attrs %{
    name: "some updated name",
    resources: [
      %{name: "humo_rbac_roles", actions: ["read", "delete"]}
    ]
  }
  @invalid_attrs %{name: nil, resources: nil}

  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(@valid_attrs)
      |> RolesService.create_role()

    role
  end

  describe "list_roles/1" do
    test "without access returns no roles" do
      fn ->
        assert [] = RolesService.list_roles(nil)
      end
      |> Mock.with_mock(can_all: &NoAccess.can_all/3)
    end

    test "with all access returns all roles" do
      role = role_fixture()
      fn ->
        assert role in RolesService.list_roles(nil)
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end
  end

  describe "get_role!/1" do
    test "returns the role with given id" do
      role = role_fixture()
      assert role == RolesService.get_role!(role.id)
    end
  end

  describe "get_roles/1" do
    test "returns the role with given id" do
      role = role_fixture()
      role_fixture(name: "another role")

      assert [role] == RolesService.get_roles([role.id])
    end
  end

  describe "create_role/1" do
    test "with valid data creates a role" do
      assert {:ok, %Role{} = role} = RolesService.create_role(@valid_attrs)
      assert "some name" == role.name
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RolesService.create_role(@invalid_attrs)
    end

    test "with duplicate role name returns error changeset" do
      assert {:ok, %Role{}} = RolesService.create_role(@valid_attrs)

      assert {:error, %Ecto.Changeset{}} = RolesService.create_role(@valid_attrs)
    end
  end

  describe "update_role/2" do
    test "with valid data updates the role" do
      role = role_fixture()
      assert {:ok, %Role{} = role} = RolesService.update_role(role, @update_attrs)
      assert "some updated name" == role.name
      assert %Resource{name: "humo_rbac_roles", actions: ["read", "delete"]} in role.resources
    end

    test "with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = RolesService.update_role(role, @invalid_attrs)
      assert RolesService.get_role!(role.id) == role
    end
  end

  describe "delete_role/1" do
    test "deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = RolesService.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> RolesService.get_role!(role.id) end
    end
  end

  describe "change_role/1" do
    test "returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = RolesService.change_role(role)
    end
  end
end
