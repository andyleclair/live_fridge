defmodule LiveFridge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :ok = LiveFridge.ConnectionCounter.init_counter()

    children = [
      LiveFridgeWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:live_fridge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveFridge.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LiveFridge.Finch},
      {PartitionSupervisor, child_spec: DynamicSupervisor, name: LiveFridge.PartitionSupervisor},
      # Start a worker by calling: LiveFridge.Worker.start_link(arg)
      # {LiveFridge.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveFridgeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveFridge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveFridgeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
