defmodule ExcmsRoleWeb.Routers.Cms do
  @moduledoc false

  defmacro __using__(_opts) do
    quote location: :keep do
      resources "/roles", ExcmsRoleWeb.Cms.RoleController

      resources "/users_roles", ExcmsRoleWeb.Cms.UserRoleController,
        only: [:index, :show, :edit, :update]
    end
  end
end
