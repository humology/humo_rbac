defmodule HumoRbac.UsersRolesService do
  @moduledoc """
  The UsersRolesService context.
  """

  import Ecto.Query, warn: false
  alias Humo.Repo

  alias HumoRbac.UsersRolesService.User
  alias HumoRbac.UsersRolesService.UserRole
  alias HumoRbac.RolesService.Role
  alias Humo.Authorizer

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
    Repo.get!(User, id)
    |> Repo.preload(:roles)
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
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_role changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
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
