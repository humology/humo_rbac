import Config

config :humo, Humo,
  deps: [
    %{app: :humo, path: "deps/humo"},
    %{app: :humo_account, path: "deps/humo_account"},
    %{app: :excms_role, path: "./"}
  ],
  server_app: :excms_role

if Path.expand("../deps/humo/config/plugin.exs", __DIR__) |> File.exists?(), do:
  import_config "../deps/humo/config/plugin.exs"

if Path.expand("../deps/humo_account/config/plugin.exs", __DIR__) |> File.exists?(), do:
  import_config "../deps/humo_account/config/plugin.exs"

if Path.expand("../config/plugin.exs", __DIR__) |> File.exists?(), do:
  import_config "../config/plugin.exs"
