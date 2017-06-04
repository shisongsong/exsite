# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :exsite,
  ecto_repos: [Exsite.Repo]

# Configures the endpoint
config :exsite, Exsite.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7l5qxVsZv7MyFrmLfx9HHBZ3Km0mwbjaAEQs4JZDCmBhJ6uV0Komb0hMjC3PsrSQ",
  render_errors: [view: Exsite.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Exsite.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :scrivener_html,
  routes_helper: Exsite.Router.Helpers,
  view_style: :bootstrap

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
