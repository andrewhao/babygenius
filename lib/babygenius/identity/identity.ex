defmodule Babygenius.Identity do
  @moduledoc """
  Public interface to the Identity context.

  This stores user account-related information
  """
  @behaviour Babygenius.Identity.Behaviour

  alias Babygenius.Repo
  alias Babygenius.Identity.{User, HashidGenerator}
  import Ecto.Query
  @event_publisher Application.get_env(:babygenius, :event_publisher)

  @impl true
  def find_or_create_user_by_amazon_id(%{amazon_id: amazon_id} = user) do
    query = from(u in User, where: u.amazon_id == ^amazon_id)
    user = Babygenius.Repo.one(query) || Babygenius.Repo.insert!(user)
    notify_user_created(user)
    user
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

  @impl true
  def get_user_by_id(user_id) do
    Repo.get_by(User, id: user_id)
  end

  def list_users do
    from(u in User)
    |> Repo.all()
    |> Enum.map(&User.slugify/1)
  end

  @spec notify_user_created(user :: %User{}) :: no_return()
  def notify_user_created(user) do
    @event_publisher.publish(:"identity.user.created", %{user: user})
  end
end