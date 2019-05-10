defmodule GenstageExample.QueueProducer do
  use GenStage

  def add({_m, _f, _a} = mfa) do
    GenStage.cast(__MODULE__, {:add, mfa})
  end

  # Client Interface Code

  @impl true
  def init(:ok) do
    {:producer, {:queue.new(), 0}}
  end

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Adds a request to the queue.

  If there is any demand it immediatly dispatches. When no demand the requests
  is enqueued and it waits for demand.
  """
  @impl true
  def handle_cast({:add, {_m, _f, _a} = event}, {queue, pending_demand}) do
    dispatch_events(:queue.in(event, queue), pending_demand, [])
  end

  @impl true
  def handle_demand(incoming_demand, {queue, pending_demand}) do
    dispatch_events(queue, incoming_demand + pending_demand, [])
  end

  @doc false
  defp dispatch_events(queue, demand, events) do
    with d when d > 0 <- demand,
         {{:value, event}, queue} <- :queue.out(queue) do
      dispatch_events(queue, demand - 1, [event | events])
    else
      _ -> {:noreply, Enum.reverse(events), {queue, demand}}
    end
  end
end
