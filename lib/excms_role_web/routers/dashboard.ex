defmodule ExcmsRoleWeb.Routers.Dashboard do
  @moduledoc false

  defmacro __using__(_opts) do
    quote location: :keep do
      resources "/roles", ExcmsRoleWeb.Dashboard.RoleController

      resources "/users_roles", ExcmsRoleWeb.Dashboard.UserRoleController,
        only: [:index, :show, :edit, :update]
    end
  end
end
