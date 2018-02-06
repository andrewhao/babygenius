defmodule BabygeniusWeb.UserController do
  use BabygeniusWeb, :controller

  alias Babygenius.{Identity, BabyLife, Locality}

  @locality_client Application.get_env(:babygenius, :locality_client)

  def index(conn, %{}) do
    users = Identity.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Identity.get_user_by_slug(id)
    events = BabyLife.list_events_for_user(user)
    setting = @locality_client.get_setting_for_user(to_string(user.id))
              |> case do
                nil -> %{zip_code: nil, timezone_identifier: nil}
                setting -> setting
              end

    render(conn, "show.html", user: user, events: events, setting: setting)
  end
end
