defmodule HumoRbacWeb.Routers.Dashboard do
  @moduledoc false

  defmacro __using__(_opts) do
    quote location: :keep do
      resources "/roles", HumoRbacWeb.Dashboard.RoleController

      resources "/users_roles", HumoRbacWeb.Dashboard.UserRoleController,
        only: [:index, :show, :edit, :update]
    end
  end
end
