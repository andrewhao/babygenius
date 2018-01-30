defmodule Babygenius.BabyLife.Client do
  @moduledoc """
  Context encapsulating the logging, recording, and aggregate reporting of
  a baby-centered set of events
  """

  @behaviour Babygenius.BabyLife

  alias Babygenius.BabyLife.DiaperChange
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
end