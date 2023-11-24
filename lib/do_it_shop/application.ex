defmodule DoItShop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DoItShopWeb.Telemetry,
      DoItShop.Repo,
      {DNSCluster, query: Application.get_env(:do_it_shop, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DoItShop.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DoItShop.Finch},
      # Start a worker by calling: DoItShop.Worker.start_link(arg)
      # {DoItShop.Worker, arg},
      # Start to serve requests, typically the last entry
      DoItShopWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DoItShop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DoItShopWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
