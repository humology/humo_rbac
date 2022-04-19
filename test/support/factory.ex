defmodule ExcmsRole.Factory do
  alias ExcmsRole.UsersRolesService.User
  alias ExcmsRole.RolesService.Role
  alias ExcmsCore.Repo


  def insert(resource, params \\ [])
  def insert(:user, params) do
    %User{
      first_name: "Jane",
      last_name: "Smith",
      email: "jane-smith@example.invalid",
      email_verified_at: DateTime.utc_now(),
      roles: []
    } |> Ecto.Changeset.change(params) |> Repo.insert!()
  end

  def insert(:role, params) do
    %Role{
      name: "role123",
      resources: []
    } |> Ecto.Changeset.change(params) |> Repo.insert!()
  end
end
