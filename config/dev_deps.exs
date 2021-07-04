use Mix.Config

config :excms_role, Excms.Deps,
  deps: [
    :ecto_sql,
    :bamboo,
    :bamboo_smtp,
    :bcrypt_elixir,
    :gettext,
    :jason,
    :phoenix,
    :phoenix_ecto,
    :phoenix_html,
    :phoenix_pubsub,
    :plug_cowboy,
    :postgrex,
    :excms_core,
    :excms_account,
    :excms_role
  ]

config :excms_server, Excms.Deps,
  deps: [
    :ecto_sql,
    :bamboo,
    :bamboo_smtp,
    :bcrypt_elixir,
    :gettext,
    :jason,
    :phoenix,
    :phoenix_ecto,
    :phoenix_html,
    :phoenix_pubsub,
    :plug_cowboy,
    :postgrex,
    :phoenix_live_dashboard,
    :phoenix_live_reload,
    :telemetry_metrics,
    :telemetry_poller,
    :excms_core,
    :excms_account,
    :excms_role,
    :excms_server
  ]

import_config "../deps/excms_core/apps/excms_core/config/config.exs"
import_config "../deps/excms_account/apps/excms_account/config/config.exs"
import_config "../apps/excms_role/config/config.exs"
