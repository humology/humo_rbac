# This file is responsible for configuring your plugin application
#
# This configuration can be partially overriden by plugin that has
# this application as dependency

# General application configuration
import Config

config :humo_rbac,
  ecto_repos: [Humo.Repo]

config :humo, :plugins,
  humo_rbac: %{
    title: "Roles",
    dashboard_links: [
      %{title: "Roles", route: :dashboard_humo_rbac_role_path, action: :index},
      %{title: "Users Roles", route: :dashboard_humo_rbac_user_role_path, action: :index}
    ]
  }

config :humo, HumoWeb.PluginsRouter, humo_rbac: HumoRbacWeb.PluginRouter

config :humo, HumoWeb.BrowserPlugs, humo_rbac: [{HumoRbacWeb.AuthorizePlug, true}]

config :humo, Humo.Warehouse,
  humo_rbac: [
    HumoRbac.RolesService.Role,
    HumoRbac.UsersRolesService.User
  ]
