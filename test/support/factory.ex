defmodule ExcmsRole.Factory do
  use ExMachina.Ecto, repo: ExcmsCore.Repo

  alias ExcmsRole.UsersRolesService.User
  alias ExcmsRole.RolesService.Role
  alias ExcmsRole.RolesService

  def user_factory do
    %User{
      first_name: "Jane",
      last_name: "Smith",
      email: sequence(:email, &"email-#{&1}@example.invalid"),
      email_verified_at: DateTime.utc_now(),
      inserted_at: DateTime.utc_now() |> DateTime.add(sequence(:user_inserted_at, & &1), :second),
      roles: []
    }
  end

  def role_factory do
    %Role{
      name: sequence(:role, &"role-#{&1}"),
      permission_resources: []
    }
  end

  def admin_user_factory do
    %User{
      first_name: "Jane",
      last_name: "Smith",
      email: sequence(:email, &"email-#{&1}@example.invalid"),
      email_verified_at: DateTime.utc_now(),
      roles:
        RolesService.list_roles()
        |> Enum.filter(&(&1.name == "administrator")),
      inserted_at:
        DateTime.utc_now()
        |> DateTime.add(sequence(:user_inserted_at, & &1), :second)
    }
  end

  def readonly_user_factory do
    %User{
      first_name: "Jane",
      last_name: "Smith",
      email: sequence(:email, &"email-#{&1}@example.invalid"),
      email_verified_at: DateTime.utc_now(),
      roles: [build(:readonly_role)],
      inserted_at:
        DateTime.utc_now()
        |> DateTime.add(sequence(:user_inserted_at, & &1), :second)
    }
  end

  def restricted_role_factory do
    %Role{
      name: "restricted",
      permission_resources: []
    }
  end

  def restricted_user_factory do
    %User{
      first_name: "Jane",
      last_name: "Smith",
      email: sequence(:email, &"email-#{&1}@example.invalid"),
      email_verified_at: DateTime.utc_now(),
      roles: [build(:restricted_role)],
      inserted_at:
        DateTime.utc_now()
        |> DateTime.add(sequence(:user_inserted_at, & &1), :second)
    }
  end
end
