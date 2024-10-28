defmodule LiveFridgeWeb.Components.Word do
  use LiveFridgeWeb, :html

  attr :word, :any, required: true

  def word(assigns) do
    ~H"""
    <div
      id={@word.id}
      draggable="true"
      phx-hook="Drag"
      class="m-3 px-3 border absolute cursor-grab"
      style={"top: #{@word.y}px; left: #{@word.x}px; box-shadow: 3px 3px 0 0 #000"}
    >
      <span class=""><%= @word.word %></span>
    </div>
    """
  end
end
