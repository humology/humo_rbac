# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

if Path.expand("#{Mix.env()}_deps.exs", __DIR__) |> File.exists?(), do:
  import_config "#{Mix.env()}_deps.exs"

config :excms_account, ExcmsAccountWeb.AuthService,
  timeout_seconds: 3600 * 24,
  secret: "sKKlOpvwOwHg+cTLFO4byayYBUWEBGCJGjgGTjdRWYkTVPNGi9gnlYAmVCWo9mVnDhgT",
  salt: "JghkDhKAHTBDTVtbtdsOTtdsgtOPGqKSHvBtGHTDgh"

config :excms_server,
  ecto_repos: [ExcmsCore.Repo]

# Configures the endpoint
config :excms_server, ExcmsServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jgcynEhO5benFFnqSS5I/tDf+62XJF3/h15CfA+N1Olg2h9n9TFZ1yiwLlWcsOwR",
  render_errors: [view: ExcmsRoleWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExcmsRole.PubSub,
  live_view: [signing_salt: "dEhMVmz4"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(assets/js/app.js --bundle --target=es2016 --outdir=priv/static/assets),
    env: %{"NODE_PATH" => Path.expand("../../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :excms_account, ExcmsAccountWeb.Mailer,
  adapter: Bamboo.SMTPAdapter,
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: true,
  retries: 3,
  no_mx_lookups: false,
  auth: :always

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"