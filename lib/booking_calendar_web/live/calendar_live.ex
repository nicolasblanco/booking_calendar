defmodule BookingCalendarWeb.CalendarLive do
  use Phoenix.LiveView

  alias BookingCalendar.Front

  def render(assigns) do
    ~L"""
    <div id="calendar">
      <div id="calendar_header">
        <i phx-click="previous_month" class="icon-chevron fas fa-chevron-left"></i>
        <h1><%= Timex.format!(@current_date, "{Mfull} {YYYY}") %></h1>
        <i phx-click="next_month" class="icon-chevron fas fa-chevron-right"></i>
      </div>
      <div id="calendar_weekdays">
        <%= for week_day <- Timex.Translator.get_weekdays_abbreviated("en") |> Map.values do %>
          <div><%= week_day %></div>
        <% end %>
      </div>
      <div id="calendar_content">
        <%= for i <- 1..(@current_date |> Date.day_of_week), i > 1 do %>
          <div class="blank"></div>
        <% end %>
        <%= for current_day <- @days do %>
          <div class="<%= if current_day.booked, do: "booked" %>" phx-click="switch_day" phx-value="<%= current_day.date %>">
            <%= current_day.date.day %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: Front.subscribe()
    current_date = Timex.beginning_of_month(Timex.today)

    {:ok, assign(socket, current_date: current_date,
                         days: Front.days_for(current_date.year, current_date.month))}
  end

  def handle_event("next_month", _, socket) do
    socket.assigns.current_date
    |> Timex.shift(months: 1)
    |> reply_with(socket)
  end

  def handle_event("previous_month", _, socket) do
    socket.assigns.current_date
    |> Timex.shift(months: -1)
    |> reply_with(socket)
  end

  def handle_event("switch_day", value, socket) do
    current_day = Date.from_iso8601!(value)
    {:ok, _day} = Front.switch_day(current_day)

    {:noreply, socket}
  end

  def handle_info({Front, :switch_day, _}, socket) do
    socket.assigns.current_date
    |> reply_with(socket)
  end

  defp reply_with(date, socket) do
    {:noreply, assign(socket, current_date: date,
                              days: Front.days_for(date.year, date.month))}
  end
end
