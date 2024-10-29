defmodule LiveFridge.PubSubNotifier do
  use Ash.Notifier

  def notify(%Ash.Notifier.Notification{action: %{type: :update}, data: data}) do
    Phoenix.PubSub.broadcast(LiveFridge.PubSub, "move_word", %{id: data.id, x: data.x, y: data.y})
  end
end
