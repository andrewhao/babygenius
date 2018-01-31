defmodule Babygenius.Identity.Client do
  @behaviour Babygenius.Identity

  alias Babygenius.Identity.User
  import Ecto.Query

  @impl true
  def find_or_create_user_by_amazon_id(user) do
    query = from(u in User, where: u.amazon_id == ^user.amazon_id)
    Babygenius.Repo.one(query) || Babygenius.Repo.insert!(user)
  end
end