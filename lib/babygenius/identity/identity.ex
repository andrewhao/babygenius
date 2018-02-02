defmodule Babygenius.Identity do
  @moduledoc """
  Public interface to the Identity context.

  This stores user account-related information
  """
  @behaviour Babygenius.Identity.Behaviour

  alias Babygenius.Repo
  alias Babygenius.Identity.{User, HashidGenerator}
  import Ecto.Query

  @impl true
  def find_or_create_user_by_amazon_id(user) do
    query = from(u in User, where: u.amazon_id == ^user.amazon_id)
    Babygenius.Repo.one(query) || Babygenius.Repo.insert!(user)
  end

  @impl true
  def get_user_by_slug(slug) do
    with {:ok, [user_id]} <- HashidGenerator.decode(slug) do
      Repo.get_by(User, id: user_id)
      |> User.slugify()
    else
      _err -> nil
    end
  end

  def list_users do
    from(u in User)
    |> Repo.all()
    |> Enum.map(&User.slugify/1)
  end
end