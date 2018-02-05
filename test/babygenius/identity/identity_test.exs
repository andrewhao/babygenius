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

  describe "find_or_create_user_by_amazon_id/1" do
    test "it creates a user" do
      %User{amazon_id: "asdf", consent_token: "consent", device_id: "device"}
      |> Identity.find_or_create_user_by_amazon_id()

      new_identity = Repo.get_by(User, amazon_id: "asdf")

      assert new_identity.id
      assert new_identity.amazon_id == "asdf"
      assert new_identity.consent_token == "consent"
      assert new_identity.device_id == "device"
    end

    test "it finds a user if exists" do
      existing_user = insert(:user, amazon_id: "asdfasdf")

      result =
        %User{amazon_id: "asdfasdf"}
        |> Identity.find_or_create_user_by_amazon_id()

      assert result.id == existing_user.id
    end

    @tag :skip
    test "it fires a identity.user.created event" do
      %User{amazon_id: "asdfasdf"}
      |> Identity.find_or_create_user_by_amazon_id()
    end
  end
end