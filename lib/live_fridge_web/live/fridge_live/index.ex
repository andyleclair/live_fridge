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

    <div class="fixed bottom-0 left-0 m-5 p-4">
      <div class="flex items-center gap-2">
        <.icon name="hero-bolt-solid" class="bg-green-500" />
        <%= @users_online %> poets online
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(LiveFridge.PubSub, "word")
      Phoenix.PubSub.subscribe(LiveFridge.PubSub, "user")
      LiveFridge.ConnectionCounter.incr()
    end

    {:ok,
     socket
     |> assign(all_words: all_words())
     |> assign(users_online: LiveFridge.ConnectionCounter.get())
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

    {:noreply,
     assign(socket,
       users_online: LiveFridge.ConnectionCounter.get(),
       all_words: Map.put(all_words, id, %{word | x: x, y: y})
     )}
  end

  # You might think, "andy, you're just setting the form to the value that's set on the form" and
  # you would be right! however, if you don't set the value _here_ in _Phoenix_, then Phoenix doesn't know
  # the form has changed, and when you submit the form, the form field won't get cleared. This is a bit of
  # LiveView that you sorta just need to get used to.
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
         |> assign(new_word_form: new_form(), errors: changeset.errors)
         |> put_flash(:error, "Failed to add word")}
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

  @impl true
  def handle_info(%{event: :user_left}, socket) do
    {:noreply, assign(socket, users_online: LiveFridge.ConnectionCounter.get())}
  end

  @impl true
  def handle_info(%{event: :user_joined}, socket) do
    {:noreply, assign(socket, users_online: LiveFridge.ConnectionCounter.get())}
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
