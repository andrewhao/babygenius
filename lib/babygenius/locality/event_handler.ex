defmodule Babygenius.Locality.EventHandler do
  @locality_client Application.get_env(:babygenius, :locality_client)

  use ExActor.GenServer

  defstart(start_link, do: initial_state(0))

  def process(event_shadow) do
    Apex.ap("Process")
    Apex.ap(event_shadow)
    GenServer.cast(__MODULE__, event_shadow)
    :ok
  end

  @impl true
  def handle_cast({:"identity.user.created", id}, state) do
    Apex.ap("handle_cast")
    Apex.ap(state)
    %{data: event_data} = EventBus.fetch_event({:"identity.user.created", id})
    Apex.ap(event_data)

    {:ok, _pid} = @locality_client.trigger_zipcode_lookup(event_data.user_id)

    # update the watcher!
    EventBus.mark_as_completed({__MODULE__, :"identity.user.created", id})

    {:noreply, state}
  end

  @impl true
  def handle_cast({topic, id}, state) do
    EventBus.mark_as_skipped({__MODULE__, topic, id})
    {:noreply, state}
  end
end