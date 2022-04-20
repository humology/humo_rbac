defmodule HumoRbac.UsersRolesService.UserRole do
  use Ecto.Schema
  alias HumoAccount.UsersService.User
  alias HumoRbac.RolesService.Role

  schema "humo_rbac_users_roles" do
    belongs_to :user, User, type: :binary_id
    belongs_to :role, Role

    timestamps(updated_at: false)
  end

  defmodule Helpers do
    use Humo.EctoResourceHelpers
  end
end
