defmodule Babygenius.Locality.EventHandler do
  @locality_client Application.get_env(:babygenius, :locality_client)

  use ExActor.GenServer

  @impl true
  def init(:ok) do
    {:ok, []}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def process(event_shadow) do
    GenServer.cast(__MODULE__, event_shadow)
    :ok
  end

  @impl true
  def handle_cast({:"identity.user.created" = event_name, id}, state) do
    %{data: event_data} = EventBus.fetch_event({event_name, id})

    {:ok, _pid} = @locality_client.trigger_zipcode_lookup(event_data.user.id)

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
