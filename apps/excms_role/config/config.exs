use Mix.Config

# Configure Mix tasks and generators
config :excms_role,
  ecto_repos: [ExcmsCore.Repo]

config :excms_core, :plugins,
  excms_role: %{
    title: "Roles",
    cms_links: [
      %{title: "Roles", route: :cms_role_path, action: :index},
      %{title: "Users Roles", route: :cms_user_role_path, action: :index}
    ]
  }

config :excms_core, ExcmsCoreWeb.PluginsRouter,
  excms_role: %{
    cms_routers: [ExcmsRoleWeb.Routers.Cms]
  }

config :excms_core, ExcmsCoreWeb.BrowserPlugs,
  excms_core: [ExcmsCoreWeb.LocalePlug],
  excms_role: [ExcmsRoleWeb.AuthorizePlug]

config :excms_core, ExcmsCore.Warehouse,
  excms_role: [ExcmsRole.RolesService.Role, ExcmsRole.UsersRolesService.UserRole]
