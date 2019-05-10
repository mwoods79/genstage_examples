defmodule GenstageExample.DatabaseProducer do
  use GenStage

  alias GenstageExample.Database

  def add({_m, _f, _a} = mfa) do
    mfa
    |> encode()
    |> Database.insert_task()

    Process.send(__MODULE__, :enqueued, [])
    :ok
  end

  # Client Interface Code

  @impl true
  def init(:ok) do
    {:producer, 0}
  end

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def handle_cast(:enqueued, state) do
    serve_jobs(state)
  end

  @impl true
  def handle_demand(demand, state) do
    serve_jobs(demand + state)
  end

  @impl true
  def handle_info(:enqueued, state) do
    {count, tasks} = Database.take_tasks(state)
    ts = tasks |> Enum.map(fn t -> decode(t) end)
    {:noreply, ts, state - count}
  end

  def serve_jobs(limit) do
    {count, tasks} = Database.take_tasks(limit)
    ts = tasks |> Enum.map(fn t -> decode(t) end)
    Process.send_after(__MODULE__, :enqueued, 60_000)
    {:noreply, ts, limit - count}
  end

  def encode(payload) do
    payload |> :erlang.term_to_binary()
  end

  def decode(binary) do
    binary |> :erlang.binary_to_term()
  end
end
