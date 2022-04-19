import Config

# Configure Mix tasks and generators
config :excms_role,
  ecto_repos: [ExcmsCore.Repo]

config :excms_core, :plugins,
  excms_role: %{
    title: "Roles",
    dashboard_links: [
      %{title: "Roles", route: :dashboard_role_path, action: :index},
      %{title: "Users Roles", route: :dashboard_user_role_path, action: :index}
    ]
  }

config :excms_core, ExcmsCoreWeb.PluginsRouter,
  excms_role: %{
    dashboard_routers: [ExcmsRoleWeb.Routers.Dashboard]
  }

config :excms_core, ExcmsCoreWeb.BrowserPlugs,
  excms_core: [{ExcmsCoreWeb.SetAdministratorPlug, false}],
  excms_role: [{ExcmsRoleWeb.AuthorizePlug, true}]

config :excms_core, ExcmsCore.Warehouse,
  excms_role: [
    ExcmsRole.RolesService.Role,
    ExcmsRole.UsersRolesService.User
  ]
