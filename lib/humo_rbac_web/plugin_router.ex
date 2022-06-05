defmodule HumoRbacWeb.PluginRouter do
  @moduledoc false

  use HumoWeb.PluginRouterBehaviour

  def dashboard() do
    quote location: :keep do
      resources "/roles", HumoRbacWeb.Dashboard.RoleController

      resources "/users_roles", HumoRbacWeb.Dashboard.UserRoleController,
        only: [:index, :show, :edit, :update]
    end
  end
end
