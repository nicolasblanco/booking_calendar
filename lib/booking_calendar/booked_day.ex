defmodule BookingCalendar.BookedDay do
  use Ecto.Schema
  import Ecto.Changeset

  schema "booked_days" do
    field :booked, :boolean, default: true
    field :date, :date

    timestamps()
  end

  @doc false
  def changeset(booked_day, attrs) do
    booked_day
    |> cast(attrs, [:date, :booked])
    |> validate_required([:date, :booked])
  end
end
