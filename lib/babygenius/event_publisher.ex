defmodule Babygenius.EventPublisher.Behaviour do
  @callback publish(topic :: atom(), payload :: map()) :: no_return()
end

defmodule Babygenius.EventPublisher do
  use EventBus.EventSource
  @behaviour Babygenius.EventPublisher.Behaviour

  @impl true
  def publish(topic, payload) do
    EventSource.notify %{
      id: UUID.uuid4(),
      topic: topic
    } do
      payload
    end
  end
end