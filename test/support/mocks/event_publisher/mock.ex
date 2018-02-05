defmodule Babygenius.EventPublisher.Mock do
  @behaviour Babygenius.EventPublisher.Behaviour
  @verbose false

  @impl true
  def publish(event, payload) do
    if @verbose do
      IO.puts("[EventPublisher.Mock] #{event}:")
      IO.inspect(payload)
    end

    nil
  end
end