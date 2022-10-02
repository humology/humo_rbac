defmodule HumoRbac.UsersRolesService do
  @moduledoc """
  The UsersRolesService context.
  """

  import Ecto.Query, warn: false
  alias Humo.Repo

  alias HumoAccount.UsersService.User
  alias HumoRbac.UsersRolesService.UserWithRoles
  alias HumoRbac.UsersRolesService.UserRole
  alias HumoRbac.RolesService.Role
  alias Humo.Authorizer
  alias Ecto.Changeset

  alias Ecto.Multi

  @doc """
  Returns list of users by page, size and optional search query.

  ## Examples

      iex> page_users(authorization, page, size, search)
      [%User{}, ...]

  """
  def page_users(authorization, page, size, search) do
    Authorizer.can_all(authorization, "read", User)
    |> match_search(search)
    |> sort_by_inserted_at()
    |> paginate(page, size)
    |> Repo.all()
    |> Repo.preload(:roles)
  end

  @doc """
  Returns users count by optional search query.

  ## Examples

      iex> count_users(authorization, search)
      3

  """
  def count_users(authorization, search) do
    Authorizer.can_all(authorization, "read", User)
    |> match_search(search)
    |> do_count_users()
  end

  @doc """
  Gets a single user with roles.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    user = Repo.get!(User, id)

    from(r in Role,
      join: ur in UserRole,
      on: ur.role_id == r.id and ur.user_id == ^user.id,
      select: %{role: r, user_role: ur}
    )
    |> Repo.all()
    |> then(fn user_roles ->
      %UserWithRoles{
        user: user,
        user_roles: Enum.map(user_roles, & &1.user_role),
        roles: Enum.map(user_roles, & &1.role)
      }
    end)
  end

  @doc """
  Updates a user_role.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%UserWithRoles{} = user, attrs) do
    # changes: #Ecto.Changeset<
    #   action: nil,
    #   changes: %{
    #     roles: [
    #       #Ecto.Changeset<action: :update, changes: %{}, errors: [],
    #        data: #HumoRbac.RolesService.Role<>, valid?: true>,
    #       #Ecto.Changeset<action: :update, changes: %{}, errors: [],
    #        data: #HumoRbac.RolesService.Role<>, valid?: true>
    #     ]
    #   },
    #   errors: [],
    #   data: #HumoRbac.UsersRolesService.UserWithRoles<>,
    #   valid?: true
    # >
    changes =
      UserWithRoles.changeset(user, attrs |> IO.inspect(label: "attrs"))
      |> IO.inspect(label: "changes")

    role_changes =
      (Changeset.get_change(changes, :roles) ||
         [])
      |> IO.inspect(label: "role_changes")

    Multi.new()
    |> then(fn updates ->
      Enum.reduce(role_changes, updates, fn role_change, updates ->
        case Enum.find(user.roles, &(&1.id == get_field(role_change.id))) do
          nil ->
            Multi.insert(updates, :role, %UserRole{
              user_id: user.user.id,
              role_id: get_field(role_change.id)
            })

          _ ->
            Multi.update(updates, :role, UserRole.changeset(role_change, %{}))
        end
      end)
    end)
    |> Repo.transaction()
    |> IO.inspect()
    |> case do
      {:ok, _} -> {:ok, get_user!(user.user.id)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_role changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%UserWithRoles{} = user) do
    UserWithRoles.changeset(user, %{})
  end

  defp do_count_users(query) do
    Repo.aggregate(query, :count, :id)
  end

  defp match_search(query, search) when search in [nil, ""] do
    query
  end

  defp match_search(query, search) do
    case Ecto.UUID.cast(search) do
      {:ok, _} ->
        from u in query,
          where: u.id == ^search

      :error ->
        search = "%#{search}%"

        from u in query,
          join: ur in UserRole,
          on: ur.user_id == u.id,
          join: r in Role,
          on: r.id == ur.role_id,
          where:
            ilike(u.first_name, ^search) or
              ilike(u.last_name, ^search) or
              ilike(u.email, ^search) or
              ilike(r.name, ^search)
    end
  end

  defp sort_by_inserted_at(query) do
    from u in query,
      order_by: [desc: u.inserted_at]
  end

  defp paginate(query, page, size) when page > 0 and size > 0 do
    from query,
      limit: ^size,
      offset: ^((page - 1) * size)
  end
end
