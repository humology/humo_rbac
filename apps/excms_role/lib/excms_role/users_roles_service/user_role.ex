defmodule ExcmsRole.UsersRolesService.UserRole do
  use Ecto.Schema
  use ExcmsCore.Resource
  alias ExcmsAccount.UsersService.User
  alias ExcmsRole.RolesService.Role

  schema "users_roles" do
    belongs_to :user, User, type: :binary_id
    belongs_to :role, Role

    timestamps(updated_at: false)
  end
end
