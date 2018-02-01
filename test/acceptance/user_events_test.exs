defmodule Babygenius.UserEventsTest do
  use Babygenius.AcceptanceCase, async: true

  alias Babygenius.Identity.User

  test "list user events", %{session: session} do
    user =
      insert(:user)
      |> User.slugify()

    page_text =
      session
      |> visit("/users/#{user.slug}")
      |> text()

    assert page_text =~ "Welcome"
  end
end