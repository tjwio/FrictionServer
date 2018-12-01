# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :friction_server,
  ecto_repos: [FrictionServer.Repo]

# Configures the endpoint
config :friction_server, FrictionServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jmj7UoyueKQriFKyh+MQ7jWe5uLswggOAGm9k97ajPcUVtJKwmoJRlb6Vs0p4T6t",
  render_errors: [view: FrictionServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FrictionServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Guardian
config :friction_server, FrictionServer.Authentication.Guardian,
       issuer: "friction_server",
       ttl: { 30, :days },
       allowed_drift: 2000,
       secret_key: "9oci+UKjjuGCcbpqrTDdSHS+pDWKjO/o3slHuTnPzhvTwRTcLuNR10my4Y3v7A4q"

config :pigeon, :apns,
       apns_default: %{
         cert: "production_io.tjw.friction.pem",
         key: "production_io.tjw.friction.pkey",
         mode: :dev
       }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
