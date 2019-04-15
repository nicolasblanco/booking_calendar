use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :booking_calendar, BookingCalendarWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :booking_calendar, BookingCalendar.Repo,
  username: "postgres",
  password: "postgres",
  database: "booking_calendar_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
