import Config

config :humo, Humo,
  apps: [
    %{app: :humo, path: "deps/humo"},
    %{app: :humo_account, path: "deps/humo_account"},
    %{app: :humo_rbac, path: "./"}
  ],
  server_app: :humo_rbac

if Path.expand("../deps/humo/config/plugin.exs", __DIR__) |> File.exists?(),
  do: import_config("../deps/humo/config/plugin.exs")

if Path.expand("../deps/humo_account/config/plugin.exs", __DIR__) |> File.exists?(),
  do: import_config("../deps/humo_account/config/plugin.exs")

if Path.expand("../config/plugin.exs", __DIR__) |> File.exists?(),
  do: import_config("../config/plugin.exs")
