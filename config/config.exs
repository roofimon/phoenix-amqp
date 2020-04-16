# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :genserv,
  ecto_repos: [Genserv.Repo]

# Configures the endpoint
config :genserv, GenservWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "v37vHV3w8ulFSvEu34VdMkoMuXo92G+ETXJDFFURgD8RmHceaQ6dP3RCR3M/i42+",
  render_errors: [view: GenservWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Genserv.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "SAKkowjl"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
