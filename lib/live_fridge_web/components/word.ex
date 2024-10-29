defmodule LiveFridgeWeb.Components.Word do
  use LiveFridgeWeb, :html

  attr :word, :any, required: true

  def word(assigns) do
    ~H"""
    <div
      id={@word.id}
      phx-hook="Drag"
      class="word px-4 py-1 border absolute cursor-grab bg-white"
      style={"top: #{@word.y}px; left: #{@word.x}px; box-shadow: 3px 3px 0 0 #{@word.color}"}
    >
      <span class=""><%= @word.word %></span>
    </div>
    """
  end
end
