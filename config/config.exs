# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :booking_calendar,
  ecto_repos: [BookingCalendar.Repo]

# Configures the endpoint
config :booking_calendar, BookingCalendarWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "x/RaJMEfVCIDIzaCiG8Gn5sfg1CazZJt70wWspCTNpHzwp/B18xI4QLxW/z6fbny",
  render_errors: [view: BookingCalendarWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BookingCalendar.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "oel2QWyjS+f1wfbAvUqHs9keBohhqdIJ"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
