defmodule HumoRBACWeb.Routers.Dashboard do
  @moduledoc false

  defmacro __using__(_opts) do
    quote location: :keep do
      resources "/roles", HumoRBACWeb.Dashboard.RoleController

      resources "/users_roles", HumoRBACWeb.Dashboard.UserRoleController,
        only: [:index, :show, :edit, :update]
    end
  end
end
