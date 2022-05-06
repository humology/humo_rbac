import Config

# Configure Mix tasks and generators
config :humo_rbac,
  ecto_repos: [Humo.Repo]

config :humo, :plugins,
  humo_rbac: %{
    title: "Roles",
    dashboard_links: [
      %{title: "Roles", route: :dashboard_role_path, action: :index},
      %{title: "Users Roles", route: :dashboard_user_role_path, action: :index}
    ]
  }

config :humo, HumoWeb.PluginsRouter,
  humo_rbac: HumoRbacWeb.PluginRouter

config :humo, HumoWeb.BrowserPlugs,
  humo: [{HumoWeb.SetAdministratorPlug, false}],
  humo_rbac: [{HumoRbacWeb.AuthorizePlug, true}]

config :humo, Humo.Warehouse,
  humo_rbac: [
    HumoRbac.RolesService.Role,
    HumoRbac.UsersRolesService.User
  ]
