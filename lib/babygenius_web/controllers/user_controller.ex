defmodule BabygeniusWeb.UserController do
  use BabygeniusWeb, :controller

  alias Babygenius.{Identity, BabyLife}

  def index(conn, %{}) do
    users = Identity.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Identity.get_user_by_slug(id)
    events = BabyLife.list_events_for_user(user)

    render(conn, "show.html", user: user, events: events)
  end
end