defmodule Babygenius.Identity do
  @moduledoc """
  Public interface to the Identity context.

  This stores user account-related information
  """
  @callback find_or_create_user_by_amazon_id(user :: %Babygenius.Identity.User{}) ::
              %Babygenius.Identity.User{}
end