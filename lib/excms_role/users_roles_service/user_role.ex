defmodule ExcmsRole.UsersRolesService.UserRole do
  use Ecto.Schema
  alias ExcmsAccount.UsersService.User
  alias ExcmsRole.RolesService.Role

  schema "excms_role_users_roles" do
    belongs_to :user, User, type: :binary_id
    belongs_to :role, Role

    timestamps(updated_at: false)
  end

  defmodule Helpers do
    use ExcmsCore.EctoResourceHelpers
  end
end
