defmodule BookingCalendar.Front do
  import Ecto.Query, only: [from: 2]
  alias BookingCalendar.{BookedDay, Repo}

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(BookingCalendar.PubSub, @topic)
  end

  def days_for(year, month) do
    booked_days = list_booked_days_for(year, month)

    Date.range(Timex.beginning_of_month(year, month), Timex.end_of_month(year, month))
    |> Enum.map(fn date_of_day ->
      booked = Enum.find(booked_days, &(&1.date == date_of_day && &1.booked))

      %{date: date_of_day, booked: booked}
    end)
  end

  def list_booked_days_for(year, month) do
    from(bd in BookedDay,
         where: fragment("extract(month from ?)", bd.date) == ^month and
                fragment("extract(year from ?)", bd.date) == ^year and
                bd.booked == true)
    |> Repo.all()
  end

  def switch_day(date) do
    case Repo.get_by(BookedDay, date: date) do
      nil -> BookedDay.changeset(%BookedDay{}, %{date: date})
      existing_day -> BookedDay.changeset(existing_day, %{booked: !existing_day.booked})
    end
    |> Repo.insert_or_update()
    |> notify_subscribers(:switch_day)
  end

  defp notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(BookingCalendar.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}
end
