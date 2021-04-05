defmodule ExcmsRole.Factory do
  use ExMachina.Ecto, repo: ExcmsCore.Repo

  alias ExcmsRole.UsersRolesService.User
  alias ExcmsRole.RolesService.Role

  def user_factory do
    %User{
      first_name: "Jane",
      last_name: "Smith",
      email: sequence(:email, &"email-#{&1}@example.invalid"),
      email_verified_at: DateTime.utc_now(),
      inserted_at: DateTime.utc_now() |> DateTime.add(sequence(:user_inserted_at, &(&1)), :second),
      roles: []
    }
  end

  def role_factory do
    %Role{
      name: sequence(:role, &"role-#{&1}"),
      create: [],
      read: [],
      update: [],
      delete: []
    }
  end
end
