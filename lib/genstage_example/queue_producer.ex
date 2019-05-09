defmodule GenstageExample.QueueProducer do
  use GenStage

  def add({_m, _f, _a} = mfa) do
    GenStage.call(__MODULE__, {:add, mfa})
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
  def handle_call({:add, {_m, _f, _a} = event}, from, {queue, pending_demand}) do
    dispatch_events(:queue.in({from, event}, queue), pending_demand, [])
  end

  @doc """
  GenStage callback to handle demand from consumers. This must be implemented
  for Producer stages.

  Because our implementation is more of a dispatcher we store the demand so
  that when requests come in they can immediately be dispatched to consumers.

  If a consumer has demand for 10 and there is 1 request in the queue:
  1. The one request will be dispatched
  2. A demand of 9 will be stored
  3. Future requests will be immediately dispatched until demand is zero.

  If a consumer has demand for 10 and there is 11 reqeusts in the queue:
  1. Ten requests will be dispatched
  2. A demand of 0 will be stored
  3. One request will remain in the queue waiting for demand
  """
  @impl true
  def handle_demand(incoming_demand, {queue, pending_demand}) do
    dispatch_events(queue, incoming_demand + pending_demand, [])
  end

  @doc false
  defp dispatch_events(queue, demand, events) do
    with d when d > 0 <- demand,
         {{:value, {from, event}}, queue} <- :queue.out(queue) do
      GenStage.reply(from, :ok)
      dispatch_events(queue, demand - 1, [event | events])
    else
      _ -> {:noreply, Enum.reverse(events), {queue, demand}}
    end
  end
end
