defmodule LiveFridgeWeb.FridgeLive.Index do
  use LiveFridgeWeb, :live_view
  import LiveFridgeWeb.Components.Word

  @most_used_words ~w(
    a
    about
    all
    also
    and
    as
    at
    be
    because
    but
    by
    can
    come
    could
    day
    do
    even
    find
    first
    for
    from
    get
    give
    go
    have
    he
    her
    here
    him
    his
    how
    I
    if
    in
    into
    it
    its
    just
    know
    like
    look
    make
    man
    many
    me
    more
    my
    new
    no
    not
    now
    of
    on
    one
    only
    or
    other
    our
    out
    people
    say
    see
    she
    so
    some
    take
    tell
    than
    that
    the
    their
    them
    then
    there
    these
    they
    thing
    think
    this
    those
    time
    to
    two
    up
    use
    very
    want
    way
    we
    well
    what
    when
    which
    who
    will
    with
    would
    year
    you
    your
  )

  @impl true
  def render(assigns) do
    ~H"""
    <.word :for={{_id, word} <- @most_used_words} word={word} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, most_used_words: make_words())}
  end

  @impl true
  def handle_event("drop", %{"id" => id, "x" => x, "y" => y}, socket) do
    word = Map.get(socket.assigns, :most_used_words) |> Map.get(id)
    {:noreply, assign(socket, most_used_words: Map.put(socket.assigns.most_used_words, id, %{word | x: x, y: y}))}
  end

  defp make_words() do
    @most_used_words
      |> Enum.map(fn word ->
    Ash.create!(LiveFridge.Fridge.Word, %{word: word, x: :rand.uniform(2500), y: :rand.uniform(2500)})
end)
      |> Map.new(fn word -> {word.id, word} end)
        
  end
end
