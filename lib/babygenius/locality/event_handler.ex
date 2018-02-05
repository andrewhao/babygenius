defmodule Babygenius.Locality.EventHandler do
  use ExActor.GenServer

  defstart start_link, do: initial_state(0)

  def process({topic, id} = event_shadow) do
    GenServer.cast(__MODULE__, event_shadow)
    :ok
  end

  def handle_cast({:"identity.user.created", id}, state) do
    event = EventBus.fetch_event({:"identity.user.created", id})

    Apex.ap(event)

    # update the watcher!
    EventBus.mark_as_completed({__MODULE__, :"identity.user.created", id})
    {:noreply, state}
  end

  def handle_cast({topic, id}, state) do
    EventBus.mark_as_skipped({__MODULE__, topic, id})
    {:noreply, state}
  end
end
