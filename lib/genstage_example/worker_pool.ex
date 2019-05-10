defmodule GenstageExample.WorkerPool do
  @moduledoc """
  Very similiar to a worker pool, except that it always spawns new processes
  instead of recycling them.

  If the max_demand is set to 10 then there will never be more than 10
  processes doing work.
  """
  use ConsumerSupervisor

  def start_link(_opts) do
    ConsumerSupervisor.start_link(__MODULE__, :ok)
  end

  # Callbacks

  @impl true
  def init(:ok) do
    children = [
      worker(GenstageExample.Worker, [], restart: :temporary)
    ]

    {:ok, children, strategy: :one_for_one, subscribe_to: [GenstageExample.DatabaseProducer]}
  end
end
