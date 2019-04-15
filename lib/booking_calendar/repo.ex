defmodule BookingCalendar.Repo do
  use Ecto.Repo,
    otp_app: :booking_calendar,
    adapter: Ecto.Adapters.Postgres
end
