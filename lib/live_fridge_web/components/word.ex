defmodule LiveFridgeWeb.Components.Word do
  use LiveFridgeWeb, :html

  def word(assigns) do
    ~H"""
    <div draggable="true" class={"m-3 px-3 border absolute"} style={"top: #{@y}px; left: #{@x}px"}>
      <span class=""><%= @word %></span>
    </div>
    """
  end
end
