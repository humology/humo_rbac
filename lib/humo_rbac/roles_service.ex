defmodule HumoRBAC.RolesService do
  @moduledoc """
  The RolesService context.
  """

  import Ecto.Query, warn: false
  alias Humo.Repo

  alias HumoRBAC.RolesService.Role
  alias Humo.Authorizer

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles(authorization)
      [%Role{}, ...]

  """
  def list_roles(authorization) do
    Authorizer.can_all(authorization, "read", Role)
    |> Repo.all()
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Gets roles by ids.

  ## Examples

      iex> get_roles([123])
      [%Role{}]

  """
  def get_roles(ids) when is_list(ids) do
    Repo.all(from r in Role, where: r.id in ^ids)
  end

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{source: %Role{}}

  """
  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end
end
