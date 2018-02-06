defmodule Babygenius.UserEventsTest do
  use Babygenius.AcceptanceCase, async: true
  import Mox

  alias Babygenius.Identity.User

  setup :verify_on_exit!

  setup do
    user =
      insert(:user)
      |> User.slugify()

    %{user: user}
  end

  @tag :skip
  test "render page and list events", %{session: session, user: user} do
    Babygenius.Locality.Mock
    |> expect(:get_setting_for_user, fn _ -> nil end)

    insert(:diaper_change, user: user)
    insert(:feeding, user: user)

    page_text =
      session
      |> visit("/u/#{user.slug}")
      |> text()

    assert page_text =~ "Baby Genius for User #{user.slug}"
    assert page_text =~ "Diaper Change"
    assert page_text =~ "Feeding"
  end
end
