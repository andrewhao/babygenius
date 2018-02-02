defmodule BabygeniusWeb.UserControllerTest do
  use BabygeniusWeb.ConnCase

  alias Babygenius.Identity
  alias Babygenius.Identity.User

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:user) do
    insert(:user) |> User.slugify()
  end

  describe "show user" do
    test "renders page", %{conn: conn} do
      user = fixture(:user)
      conn = get(conn, user_path(conn, :show, user.slug))
      assert html_response(conn, 200) =~ "User"
    end
  end
end