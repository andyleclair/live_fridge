defmodule LiveFridge.Seeds do
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

  def run() do
    fridge =
      Ash.create!(LiveFridge.Fridge.Fridge, %{
        name: "The Fridge"
      })

    Enum.each(@most_used_words, fn word ->
      Ash.create!(LiveFridge.Fridge.Word, %{
        fridge_id: fridge.id,
        word: word,
        x: :rand.uniform(2500),
        y: :rand.uniform(2500)
      })
    end)
  end

  def create_fridge(fridge_name) do
    fridge =
      Ash.create!(LiveFridge.Fridge.Fridge, %{
        name: fridge_name
      })

    words =
      Map.new(@most_used_words, fn word ->
        word =
          Ash.create!(LiveFridge.Fridge.Word, %{
            fridge_id: fridge.id,
            word: word,
            x: :rand.uniform(2500),
            y: :rand.uniform(2500)
          })

        {word.id, word}
      end)

    {fridge, words}
  end
end
