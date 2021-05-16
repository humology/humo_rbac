defmodule ExcmsRole.UsersRolesService do
  @moduledoc """
  The UsersRolesService context.
  """

  import Ecto.Query, warn: false
  alias ExcmsCore.Repo

  alias ExcmsRole.UsersRolesService.User
  alias ExcmsRole.UsersRolesService.UserRole
  alias ExcmsRole.RolesService.Role
  alias ExcmsCore.Warehouse
  alias ExcmsCore.Permission

  @doc """
  Returns list of users by page, size and optional search query.

  ## Examples

      iex> page_users(page, size, search)
      [%User{}, ...]

  """
  def page_users(page, size, search) do
    User
    |> match_search(search)
    |> sort_by_inserted_at()
    |> paginate(page, size)
    |> Repo.all()
    |> Repo.preload(:roles)
  end

  @doc """
  Returns users count by optional search query.

  ## Examples

      iex> count_users(search)
      3

  """
  def count_users(search) do
    User
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
    Repo.get!(User, id)
    |> Repo.preload(:roles)
  end

  @doc """
  Gets a single user with roles.

  Returns nil if the User does not exist.

  ## Examples

      iex> get_user(123)
      %User{roles: [%Role{}]}

      iex> get_user(456)
      nil

  """
  def get_user(id) do
    Repo.get(User, id)
    |> Repo.preload(:roles)
  end

  def get_permissions(id) do
    get_user(id)
    |> Map.fetch!(:roles)
    |> roles_to_permissions()
  end

  defp roles_to_permissions(roles) do
    names_resources = Warehouse.names_resources()

    roles
    |> Enum.map(fn role ->
      role.permission_resources
      |> Enum.filter(fn x -> Map.has_key?(names_resources, x.name) end)
      |> Enum.flat_map(fn x ->
        x.permission_actions
        |> Enum.map(fn y ->
          %{resource_name: x.name, action: y.name, access_level: y.access_level}
        end)
      end)
      |> Enum.map(fn x ->
        resource = Map.fetch!(names_resources, x.resource_name)
        Permission.unsafe_new(resource, x.action, x.access_level)
      end)
      |> Enum.filter(fn x -> Permission.validate(x) == :ok end)
    end)
    |> Permission.union()
  end

  @doc """
  Updates a user_role.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.roles_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_role changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.roles_changeset(user, %{})
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
