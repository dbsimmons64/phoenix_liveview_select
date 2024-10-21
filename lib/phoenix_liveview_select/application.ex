defmodule PhoenixLiveviewSelect.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixLiveviewSelectWeb.Telemetry,
      PhoenixLiveviewSelect.Repo,
      {DNSCluster, query: Application.get_env(:phoenix_liveview_select, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixLiveviewSelect.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixLiveviewSelect.Finch},
      # Start a worker by calling: PhoenixLiveviewSelect.Worker.start_link(arg)
      # {PhoenixLiveviewSelect.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixLiveviewSelectWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixLiveviewSelect.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixLiveviewSelectWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
