defmodule LiveFridgeWeb.FridgeLive.Index do
  use LiveFridgeWeb, :live_view
  import LiveFridgeWeb.Components.Word

  @impl true
  def render(assigns) do
    ~H"""
    <.word :for={{_id, word} <- @all_words} word={word} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, all_words: all_words())}
  end

  @impl true
  def handle_event("drop", %{"id" => id, "x" => x, "y" => y}, %{assigns: %{all_words: all_words}} = socket) do
    word = all_words[id]

    Ash.update!(word, %{x: x, y: y})

    {:noreply,
     assign(socket,
       all_words: Map.put(all_words, id, %{word | x: x, y: y})
     )}
  end

  defp all_words() do
    Ash.read!(LiveFridge.Fridge.Word)
    |> Map.new(&{&1.id, &1})
  end
end
