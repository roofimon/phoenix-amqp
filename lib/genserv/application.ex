defmodule Genserv.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Genserv.Repo,
      # Start the endpoint when the application starts
      GenservWeb.Endpoint,
      # {Redix, [host: "localhost", name: :redix]},
      # {Redix.Pubsub, [host: "localhost", name: :redix_pubsub]}
      # Starts a worker by calling: Genserv.Worker.start_link(arg)
      # {Genserv.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Genserv.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GenservWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
