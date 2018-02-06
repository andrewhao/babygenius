defmodule BabygeniusWeb.UserControllerTest do
  use BabygeniusWeb.ConnCase
  import Mox

  alias Babygenius.Identity.User
  alias Babygenius.Locality.Setting

  setup :verify_on_exit!

  def fixture(:user) do
    insert(:user) |> User.slugify()
  end

  describe "show user" do
    test "renders page", %{conn: conn} do
      user = fixture(:user)
      user_id = user.id |> to_string()

      Babygenius.Locality.Mock
      |> expect(:get_setting_for_user, fn ^user_id ->
        %Setting{
          zip_code: "94606",
          timezone_identifier: "America/Los_Angeles"
        }
      end)

      conn = get(conn, user_path(conn, :show, user.slug))
      assert html_response(conn, 200) =~ "User"
    end

    test "when setting is not populated renders page", %{conn: conn} do
      user = fixture(:user)
      user_id = user.id |> to_string()

      Babygenius.Locality.Mock
      |> expect(:get_setting_for_user, fn ^user_id -> nil end)

      conn = get(conn, user_path(conn, :show, user.slug))
      assert html_response(conn, 200) =~ "User"
    end
  end
end
