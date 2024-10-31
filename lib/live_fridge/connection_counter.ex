defmodule LiveFridge.ConnectionCounter do
  @moduledoc """
  Obviously this doesn't scale well! 
  """
  use GenServer

  @impl true
  def init(_) do
    ref = :counters.new(1, [:atomics])
    {:ok, ref}
  end

  def incr() do
    GenServer.call(__MODULE__, {:incr})
  end

  def get() do
    GenServer.call(__MODULE__, {:get})
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Nice side-effect of GenServer here is I don't have to pass 
  # self() in to `incr()`, it is provided!
  @impl true
  def handle_call({:incr}, {from, _}, ref) do
    :counters.add(ref, 1, 1)
    Process.monitor(from)
    {:reply, :ok, ref}
  end

  @impl true
  def handle_call({:get}, _from, ref) do
    count = :counters.get(ref, 1)
    {:reply, count, ref}
  end

  @impl true
  def handle_info({:DOWN, _, _, _, _}, ref) do
    :counters.sub(ref, 1, 1)
    Phoenix.PubSub.broadcast(LiveFridge.PubSub, "user", %{event: :user_left})
    {:noreply, ref}
  end
end
