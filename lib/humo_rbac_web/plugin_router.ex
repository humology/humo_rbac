defmodule HumoRbacWeb.PluginRouter do
  @moduledoc false

  def root() do
    quote location: :keep do
    end
  end

  def dashboard() do
    quote location: :keep do
      resources "/roles", HumoRbacWeb.Dashboard.RoleController

      resources "/users_roles", HumoRbacWeb.Dashboard.UserRoleController,
        only: [:index, :show, :edit, :update]
    end
  end

  @doc """
  When used, dispatch to the appropriate router.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
