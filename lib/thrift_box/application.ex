defmodule ThriftBox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ThriftBoxWeb.Telemetry,
      ThriftBox.Repo,
      {DNSCluster, query: Application.get_env(:thrift_box, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ThriftBox.PubSub},
      # Start a worker by calling: ThriftBox.Worker.start_link(arg)
      # {ThriftBox.Worker, arg},
      # Start to serve requests, typically the last entry
      ThriftBoxWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ThriftBox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ThriftBoxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
