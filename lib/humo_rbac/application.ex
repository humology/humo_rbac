defmodule HumoRbac.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start a worker by calling: HumoRbac.Worker.start_link(arg)
      # {HumoRbac.Worker, arg}
    ]

    children = if Humo.is_server_app_module(__MODULE__) do
      children ++ [
        # Start the PubSub system
        {Phoenix.PubSub, name: HumoRbac.PubSub},
        # Start the Telemetry supervisor
        HumoRbacWeb.Telemetry,
        # Start the Endpoint (http/https)
        HumoRbacWeb.Endpoint
      ]
    else
      children
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HumoRbac.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HumoRbacWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
