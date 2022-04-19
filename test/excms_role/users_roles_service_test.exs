defmodule ExcmsRole.UsersRolesServiceTest do
  use ExcmsRole.DataCase, async: true

  alias ExcmsRole.UsersRolesService
  alias ExcmsRole.UsersRolesService.User
  alias ExcmsCore.Authorizer.Mock
  alias ExcmsCore.Authorizer.AllAccess
  alias ExcmsCore.Authorizer.NoAccess

  describe "page_users/4" do
    setup do
      role = insert(:role)
      user = insert(:user, roles: [role], inserted_at: ~N[2022-03-15 00:00:00])
      user2 = insert(:user, roles: [role], email: "user2@example.invalid", inserted_at: ~N[2022-03-16 00:00:00])
      user3 = insert(:user, email: "user3@example.invalid", inserted_at: ~N[2022-03-17 00:00:00])

      %{role: role, user: user, user2: user2, user3: user3}
    end

    test "without access returns no users" do
      fn ->
        assert [] == UsersRolesService.page_users(nil, 1, 2, nil)
      end
      |> Mock.with_mock(can_all: &NoAccess.can_all/3)
    end

    test "returns 2 users on 1st page", %{user2: user2, user3: user3} do
      fn ->
        assert [user3, user2] == UsersRolesService.page_users(nil, 1, 2, nil)
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end

    test "returns 1 user on 2nd page", %{user: user} do
      fn ->
        assert [user] == UsersRolesService.page_users(nil, 2, 2, nil)
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end

    test "finds user by email", %{user: user} do
      fn ->
        assert [user] == UsersRolesService.page_users(nil, 1, 5, user.email)
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end

    test "finds user by id", %{user: user} do
      fn ->
        assert [user] == UsersRolesService.page_users(nil, 1, 5, user.id)
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end

    test "finds users by role name", %{user: user, user2: user2, role: role} do
      fn ->
        assert [user2, user] == UsersRolesService.page_users(nil, 1, 5, role.name)
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end

    test "cannot find user by query" do
      fn ->
        assert [] == UsersRolesService.page_users(nil, 1, 5, "wrong search")
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end
  end

  describe "count_users/2" do
    setup do
      role = insert(:role)
      user = insert(:user, roles: [role])
      insert(:user, roles: [role], email: "user2@example.invalid")
      insert(:user, email: "user3@example.invalid")
      %{role: role, user: user}
    end

    test "without access returns 0" do
      fn ->
        assert 0 == UsersRolesService.count_users(nil, nil)
      end
      |> Mock.with_mock(can_all: &NoAccess.can_all/3)
    end

    test "with all access returns 2" do
      fn ->
        assert 3 == UsersRolesService.count_users(nil, nil)
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end

    test "when email matches, returns 1", %{user: user} do
      fn ->
        assert 1 == UsersRolesService.count_users(nil, user.email)
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end

    test "when id matches, returns 1", %{user: user} do
      fn ->
        assert 1 == UsersRolesService.count_users(nil, user.id)
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end

    test "when role name matches, returns 2", %{role: role} do
      fn ->
        assert 2 == UsersRolesService.count_users(nil, role.name)
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end

    test "when query doesn't match, returns 0" do
      fn ->
        assert 0 == UsersRolesService.count_users(nil, "wrong query")
      end
      |> Mock.with_mock(can_all: &AllAccess.can_all/3)
    end
  end

  describe "get_user!/1" do
    test "returns existing user by id" do
      role = insert(:role)
      user = insert(:user, roles: [role])

      assert user == UsersRolesService.get_user!(user.id)
    end

    test "when cannot find user by id, raises error" do
      assert_raise Ecto.NoResultsError, fn ->
        UsersRolesService.get_user!(Ecto.UUID.generate())
      end
    end
  end

  describe "update_user/2" do
    test "role addition saved" do
      role = insert(:role)
      user = insert(:user)

      assert {:ok, %User{}} = UsersRolesService.update_user(user, %{"roles" => [role.id]})
      assert [role] == UsersRolesService.get_user!(user.id).roles
    end

    test "role removal saved" do
      role = insert(:role)
      user = insert(:user, roles: [role])

      assert {:ok, %User{}} = UsersRolesService.update_user(user, %{roles: []})
      assert [] == UsersRolesService.get_user!(user.id).roles
    end
  end

  describe "change_user/1" do
    test "returns user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = UsersRolesService.change_user(user)
    end
  end
end
