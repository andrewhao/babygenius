defmodule Babygenius.UserEventsTest do
  use Babygenius.AcceptanceCase, async: true

  alias Babygenius.Identity.User

  setup do
    user =
      insert(:user)
      |> User.slugify()

    %{user: user}
  end

  test "render page and list events", %{session: session, user: user} do
    dc = insert(:diaper_change, user: user)
    feeding = insert(:feeding, user: user)

    page_text =
      session
      |> visit("/u/#{user.slug}")
      |> text()

    assert page_text =~ "Baby Genius for User #{user.slug}"
    assert page_text =~ "DiaperChange"
    assert page_text =~ "Feeding"
  end
end