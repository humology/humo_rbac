defmodule HumoRbac.MixProject do
  use Mix.Project

  @scm_url "https://github.com/humology/humo_rbac"

  def project do
    [
      app: :humo_rbac,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      package: [
        maintainers: ["Kamil Shersheyev"],
        licenses: ["Apache-2.0"],
        links: %{"GitHub" => @scm_url},
        files: ~w(assets config/plugin.exs lib priv mix.exs package.json LICENSE README.md .formatter.exs)
      ],
      source_url: @scm_url,
      humo_plugin: true,
      description: """
      Humo RBAC plugin based on Humo framework.
      """
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {HumoRbac.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.9"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      #{:humo, "~> 0.1.0"},
      {:humo, github: "humology/humo"},
      #{:humo_account, "~> 0.1.0"}
      {:humo_account, github: "humology/humo_account"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.setup", "cmd mix rest.setup"],
      "deps.setup": ["deps.get", "humo.new.config"],
      "rest.setup": ["ecto.setup", "humo.assets.setup"],
      "ecto.setup": ["ecto.create", "humo.ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "humo.ecto.migrate", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
