defmodule BookingCalendar.Repo.Migrations.CreateBookedDays do
  use Ecto.Migration

  def change do
    create table(:booked_days) do
      add :date, :date
      add :booked, :boolean, default: true, null: false

      timestamps()
    end

  end
end
