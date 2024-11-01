defmodule LiveFridge.PubSubNotifier do
  use Ash.Notifier

  def notify(%Ash.Notifier.Notification{action: %{type: :update}, data: data}) do
    Phoenix.PubSub.local_broadcast_from(LiveFridge.PubSub, self(), "word:#{data.fridge_id}", %{
      event: :update,
      id: data.id,
      x: data.x,
      y: data.y
    })
  end

  def notify(%Ash.Notifier.Notification{action: %{type: :create}, data: data}) do
    Phoenix.PubSub.local_broadcast_from(LiveFridge.PubSub, self(), "word:#{data.fridge_id}", %{
      event: :create,
      word: data
    })
  end

  def notify(%Ash.Notifier.Notification{action: %{type: :destroy}, data: data}) do
    Phoenix.PubSub.local_broadcast_from(LiveFridge.PubSub, self(), "word:#{data.fridge_id}", %{
      event: :destroy,
      id: data.id
    })
  end

  def notify(_), do: :ok
end
