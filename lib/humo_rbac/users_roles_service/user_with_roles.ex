defmodule HumoRbac.UsersRolesService.UserWithRoles do
  use Ecto.Schema
  import Ecto.Changeset
  alias HumoRbac.UsersRolesService.UserRole
  alias HumoRbac.RolesService.Role
  alias HumoAccount.UsersService.User
  alias HumoRbac.RolesService

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Inspect, only: [:id]}

  embedded_schema do
    belongs_to :user, User

    has_many :user_roles, UserRole

    many_to_many :roles, Role,
      join_keys: [user_id: :id, role_id: :id],
      join_through: UserRole,
      on_replace: :delete
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> put_assoc(:roles, get_roles(attrs))
  end

  defp get_roles(%{"roles" => ids}), do: RolesService.get_roles(ids)
  defp get_roles(_), do: []

  defmodule Helpers do
    use Humo.EctoResourceHelpers

    def name() do
      "humo_rbac_users"
    end
  end
end
