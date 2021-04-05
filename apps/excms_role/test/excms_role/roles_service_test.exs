defmodule ExcmsRole.RolesServiceTest do
  use ExcmsRole.DataCase

  alias ExcmsRole.RolesService

  describe "roles" do
    alias ExcmsRole.RolesService.Role

    @valid_attrs %{create: [], delete: [], name: "some name", read: [], update: []}
    @update_attrs %{create: [], delete: [], name: "some updated name", read: [], update: []}
    @invalid_attrs %{create: nil, delete: nil, name: nil, read: nil, update: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> RolesService.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert RolesService.list_roles()
             |> Enum.reject(&(&1.name == "administrator")) == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert RolesService.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = RolesService.create_role(@valid_attrs)
      assert role.create == []
      assert role.delete == []
      assert role.name == "some name"
      assert role.read == []
      assert role.update == []
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RolesService.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, %Role{} = role} = RolesService.update_role(role, @update_attrs)
      assert role.create == []
      assert role.delete == []
      assert role.name == "some updated name"
      assert role.read == []
      assert role.update == []
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = RolesService.update_role(role, @invalid_attrs)
      assert role == RolesService.get_role!(role.id)
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
end
