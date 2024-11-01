defmodule LiveFridge.ConnectionCounter do
  @moduledoc """
  Scalable connection counter using persistent_term and counters.
   
  It could be _more_ scalable if I hook this up so there's a global counter and 
  a local counter (a la this thread here: https://elixirforum.com/t/implementing-a-distributed-users-counter/39609/2 )
  but this should be fine for now. I do NOT plan on running several servers for this 
  cute toy
  """
  use GenServer

  def init_counter() do
    ref = :counters.new(1, [:atomics])
    # now we're cooking with gas baby
    :persistent_term.put(__MODULE__, ref)
  end

  def incr() do
    __MODULE__ |> :persistent_term.get() |> :counters.add(1, 1)

    DynamicSupervisor.start_child(
      {:via, PartitionSupervisor, {LiveFridge.PartitionSupervisor, self()}},
      {__MODULE__, self()}
    )

    Phoenix.PubSub.local_broadcast_from(LiveFridge.PubSub, self(), "user", %{event: :user_joined})

    :ok
  end

  def get() do
    __MODULE__ |> :persistent_term.get() |> :counters.get(1)
  end

  def start_link(pid) do
    GenServer.start_link(__MODULE__, [pid])
  end

  @impl true
  def init([pid]) do
    Process.monitor(pid)
    {:ok, pid}
  end

  @impl true
  def handle_info({:DOWN, _, _, _, _}, pid) do
    __MODULE__ |> :persistent_term.get() |> :counters.sub(1, 1)
    Phoenix.PubSub.local_broadcast_from(LiveFridge.PubSub, pid, "user", %{event: :user_left})
    {:noreply, pid}
  end
end
