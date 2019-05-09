defmodule GenstageExample.Consumer do
  use GenStage

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    # {:consumer, :ok, subscribe_to: [GenstageExample.BasicProducer]}
    {:consumer, :ok, subscribe_to: [GenstageExample.QueueProducer]}
  end

  def handle_events(works, _from, state) do
    works
    |> Enum.map(fn work -> Task.async(GenstageExample.Worker, :run, [work]) end)
    |> Enum.map(fn task -> Task.await(task) end)

    {:noreply, [], state}
  end
end
