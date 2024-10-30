defmodule LiveFridgeWeb.FridgeLive.Index do
  use LiveFridgeWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div
      :for={{id, word} <- @all_words}
      id={id}
      phx-hook="Drag"
      class="word px-4 py-1 border absolute cursor-grab bg-white"
      style={"top: #{word.y}px; left: #{word.x}px; box-shadow: 3px 3px 0 0 #{word.color}"}
    >
      <span class=""><%= word.word %></span>
    </div>

    <div class="fixed bottom-0 right-0 m-5 p-4">
      <.form for={@new_word_form} phx-change="change_word" phx-submit="add_word" phx-debounce="200">
        <div class="flex items-end gap-2">
          <.input field={@new_word_form["word"]} label="Add Word" />
          <.button class="" type="submit">Add</.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(LiveFridge.PubSub, "word")

    {:ok,
     socket
     |> assign(all_words: all_words())
     |> assign(new_word_form: new_form())}
  end

  @impl true
  def handle_event(
        "move",
        %{"id" => id, "x" => x, "y" => y},
        %{assigns: %{all_words: all_words}} = socket
      ) do
    word = all_words[id]

    Ash.update!(word, %{x: x, y: y})

    {:noreply, assign(socket, all_words: Map.put(all_words, id, %{word | x: x, y: y}))}
  end

  @impl true
  def handle_event("change_word", %{"word" => word}, socket) do
    {:noreply, assign(socket, new_word_form: to_form(%{"word" => word}))}
  end

  @impl true
  def handle_event("add_word", %{"word" => word}, %{assigns: %{all_words: all_words}} = socket) do
    case Ash.create(LiveFridge.Fridge.Word, %{
           word: word,
           x: rand_coordinate(),
           y: rand_coordinate()
         }) do
      {:ok, word} ->
        {:noreply,
         assign(
           socket,
           all_words: Map.put(all_words, word.id, word),
           new_word_form: new_form()
         )}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(new_word_form: new_form())
         |> put_flash(:error, "Failed to add word: #{Enum.map_join(changeset.errors, ", ", &(&1.message))}")}
    end
  end

  @impl true
  def handle_info(
        %{event: :update, id: id, x: x, y: y},
        %{assigns: %{all_words: all_words}} = socket
      ) do
    word = all_words[id]
    {:noreply, assign(socket, all_words: Map.put(all_words, id, %{word | x: x, y: y}))}
  end

  @impl true
  def handle_info(%{event: :create, word: word}, %{assigns: %{all_words: all_words}} = socket) do
    {:noreply, assign(socket, all_words: Map.put(all_words, word.id, word))}
  end

  defp all_words do
    Ash.read!(LiveFridge.Fridge.Word)
    |> Map.new(&{&1.id, &1})
  end

  defp rand_coordinate do
    Enum.random(250..500)
  end

  defp new_form do
    to_form(%{"word" => ""})
  end
end
