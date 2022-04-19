import Config

# Configure Mix tasks and generators
config :excms_role,
  ecto_repos: [Humo.Repo]

config :humo, :plugins,
  excms_role: %{
    title: "Roles",
    dashboard_links: [
      %{title: "Roles", route: :dashboard_role_path, action: :index},
      %{title: "Users Roles", route: :dashboard_user_role_path, action: :index}
    ]
  }

config :humo, HumoWeb.PluginsRouter,
  excms_role: %{
    dashboard_routers: [ExcmsRoleWeb.Routers.Dashboard]
  }

config :humo, HumoWeb.BrowserPlugs,
  humo: [{HumoWeb.SetAdministratorPlug, false}],
  excms_role: [{ExcmsRoleWeb.AuthorizePlug, true}]

config :humo, Humo.Warehouse,
  excms_role: [
    ExcmsRole.RolesService.Role,
    ExcmsRole.UsersRolesService.User
  ]
