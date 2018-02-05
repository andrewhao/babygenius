defmodule Babygenius.Identity.Behaviour do
  alias Babygenius.Identity.User

  @callback find_or_create_user_by_amazon_id(user :: %User{}) :: %User{}

  @callback get_user_by_slug(slug :: String.t()) :: %User{} | nil

  @callback get_user_by_id(String.t() | integer()) :: %User{} | nil
end