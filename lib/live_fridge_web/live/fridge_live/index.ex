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
    <.word :for={word <- @most_used_words} word={word} x={:rand.uniform(3000)} y={:rand.uniform(3000)} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, most_used_words: @most_used_words)}
  end
end