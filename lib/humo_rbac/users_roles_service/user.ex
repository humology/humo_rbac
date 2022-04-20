defmodule HumoRbac.UsersRolesService.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias HumoRbac.UsersRolesService.UserRole
  alias HumoRbac.RolesService.Role
  alias HumoRbac.RolesService

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Inspect, only: [:id]}

  schema "humo_account_users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :email_verified_at, :utc_datetime_usec, default: nil

    many_to_many :roles, Role,
      join_keys: [user_id: :id, role_id: :id],
      join_through: UserRole,
      on_replace: :delete

    timestamps()
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
