# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :timecopsync_projects_api, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: TimecopsyncProjectsApiWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: TimecopsyncProjectsApiWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }

config :timecopsync_projects_api, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [router: TimecopsyncProjectsApiWeb.Router]
  }

config :timecopsync_projects_api, :generators,
  api_prefix: "/api/v1"

config :timecopsync_projects_api,
  ecto_repos: [TimecopsyncProjectsApi.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :timecopsync_projects_api, TimecopsyncProjectsApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: TimecopsyncProjectsApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TimecopsyncProjectsApi.PubSub,
  live_view: [signing_salt: "nvBxb+wY"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :phoenix_swagger, json_library: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
