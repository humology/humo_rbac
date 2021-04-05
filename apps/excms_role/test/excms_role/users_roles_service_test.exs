defmodule ExcmsRole.UsersRolesServiceTest do
  use ExcmsRole.DataCase

  alias ExcmsRole.UsersRolesService

  describe "users_roles" do
    test "page_users/3 returns paginated users by optional search query" do
      role = insert(:role)
      user = insert(:user, roles: [role])
      user2 = insert(:user, roles: [role])
      user3 = insert(:user)

      assert UsersRolesService.page_users(1, 2, nil) == [user3, user2]
      assert UsersRolesService.page_users(2, 2, nil) == [user]
      assert UsersRolesService.page_users(1, 5, user.email) == [user]
      assert UsersRolesService.page_users(1, 5, user.id) == [user]
      assert UsersRolesService.page_users(1, 5, role.name) == [user2, user]
      assert UsersRolesService.page_users(1, 5, "some wrong search query") == []
    end

    test "count_users/1 returns user count by optional search query" do
      role = insert(:role)
      user = insert(:user, roles: [role])
      insert(:user, roles: [role])
      insert(:user)

      assert UsersRolesService.count_users(nil) == 3
      assert UsersRolesService.count_users(user.email) == 1
      assert UsersRolesService.count_users(user.id) == 1
      assert UsersRolesService.count_users(role.name) == 2
      assert UsersRolesService.count_users("some wrong search query") == 0
    end

    test "get_user!/1 returns a user with roles" do
      role = insert(:role)
      user = insert(:user, roles: [role])

      new_user = UsersRolesService.get_user!(user.id)
      assert new_user == user
      assert role.name == new_user.roles |> hd() |> Map.fetch!(:name)
    end

    test "get_user/1 returns a user with roles, if not found nil" do
      role = insert(:role)
      user = insert(:user, roles: [role])

      new_user = UsersRolesService.get_user(user.id)
      assert new_user == user
      assert role.name == new_user.roles |> hd() |> Map.fetch!(:name)

      refute UsersRolesService.get_user(Ecto.UUID.generate())
    end

    test "update_user/2 add user_role, delete user_role" do
      role = insert(:role)
      user = insert(:user)

      # add user_role
      UsersRolesService.update_user(user, %{"roles" => [role.id]})
      user_with_role = UsersRolesService.get_user!(user.id)
      assert %{user | roles: [role]} == user_with_role

      # delete user_role
      UsersRolesService.update_user(user_with_role, %{"roles" => []})
      assert user == UsersRolesService.get_user!(user.id)
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = UsersRolesService.change_user(user)
    end
  end
end
