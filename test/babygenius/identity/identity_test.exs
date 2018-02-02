defmodule Babygenius.IdentityTest do
  use Babygenius.DataCase

  alias Babygenius.Identity.User
  alias Babygenius.Identity

  describe "get_user_by_slug/1" do
    test "fetches user by slug" do
      user = insert(:user) |> User.slugify()
      assert Identity.get_user_by_slug(user.slug).id == user.id
    end

    test "slugifies the result" do
      user = insert(:user) |> User.slugify()
      assert Identity.get_user_by_slug(user.slug).slug == user.slug
    end

    test "returns nil for invalid slug" do
      assert Identity.get_user_by_slug("badslug") == nil
    end
  end
end