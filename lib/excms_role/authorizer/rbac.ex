defmodule ExcmsRole.Authorizer.RBAC do
  use ExcmsCore.Authorizer.Behaviour
  alias ExcmsCore.Repo
  alias ExcmsRole.RBACAuthorization
  alias ExcmsCore.Warehouse

  @moduledoc """
  RBAC policy gives access based on roles permissions
  Modules names are important
  """

  @impl true
  def can_all(%RBACAuthorization{} = authorization, action, resource_module) do
    if action in can_actions(authorization, resource_module) do
      resource_module
    else
      Repo.none(resource_module)
    end
  end

  @impl true
  def can_actions(%RBACAuthorization{} = authorization, %{__struct__: resource_module}) do
    can_actions(authorization, resource_module)
  end

  def can_actions(%RBACAuthorization{} = authorization, {:list, resource_module})
  when is_atom(resource_module) do
    can_actions(authorization, resource_module)
  end

  def can_actions(%RBACAuthorization{} = authorization, resource_module)
  when is_atom(resource_module) do
    if authorization.is_administrator do
      resource_actions(resource_module)
    else
      resource_name = Warehouse.resource_helpers(resource_module).name()
      Map.get(authorization.authorized_resource_actions, resource_name, [])
    end
  end
end
