defmodule Babygenius.BabyLife do
  @moduledoc """
  Context encapsulating the logging, recording, and aggregate reporting of
  a baby-centered set of events
  """

  @behaviour Babygenius.BabyLife.Behaviour

  alias Babygenius.BabyLife.{DiaperChange, Feeding, Event}
  alias Babygenius.{Repo, TimeUtils}
  import Ecto.Query

  @impl true
  def create_diaper_change(user, diaper_type, time, date, user_timezone, now) do
    diaper_change_time =
      TimeUtils.utc_time_from_local_spoken_time(
        time,
        date,
        user_timezone,
        now
      )

    %DiaperChange{user_id: user.id, type: diaper_type, occurred_at: diaper_change_time}
    |> Repo.insert!()
  end

  @impl true
  def get_last_diaper_change(user) do
    from(d in DiaperChange, where: d.user_id == ^user.id, order_by: d.occurred_at)
    |> last
    |> Repo.one()
  end

  @doc """
  Creates a feeding.

  ## Examples

      iex> create_feeding(%{field: value})
      {:ok, %Feeding{}}

      iex> create_feeding(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @impl true
  def create_feeding(
        %{
          user: user,
          feed_type: feed_type,
          volume: volume,
          unit: units,
          time: time,
          date: date,
          user_timezone: user_timezone
        } = attrs,
        now \\ Timex.now()
      ) do
    attrs =
      attrs
      |> Map.put(
        :occurred_at,
        Babygenius.TimeUtils.utc_time_from_local_spoken_time(
          time,
          date,
          user_timezone,
          now
        )
      )
      |> Map.put(:user_id, user.id)

    %Feeding{}
    |> Feeding.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking feeding changes.

  ## Examples

      iex> change_feeding(feeding)
      %Ecto.Changeset{source: %Feeding{}}

  """
  @impl true
  def change_feeding(%Feeding{} = feeding) do
    Feeding.changeset(feeding, %{})
  end

  @impl true
  def list_events_for_user(user, user_timezone \\ "Etc/UTC") do
    diaper_changes =
      from(dc in DiaperChange, where: dc.user_id == ^user.id)
      |> Repo.all()

    feedings =
      from(f in Feeding, where: f.user_id == ^user.id)
      |> Repo.all()

    diaper_changes
    |> Enum.concat(feedings)
    |> Enum.sort(&(DateTime.compare(&1.occurred_at, &2.occurred_at) in [:eq, :gt]))
    |> Enum.map(&Event.create_from(&1, user_timezone))
  end
end
