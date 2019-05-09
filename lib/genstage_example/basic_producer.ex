defmodule GenstageExample.BasicProducer do
  use GenStage

  def add({_m, _f, _a} = work) do
    GenStage.call(__MODULE__, {:add, work})
  end

  # Client Interface Code

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    {:producer, :state_doesnt_matter}
  end

  @impl true
  def handle_call({:add, {_m, _f, _a} = work}, _from, :state_doesnt_matter) do
    # immediately add the work to be done to GenStage internal buffer
    {:reply, :ok, [work], :state_doesnt_matter}
  end

  @impl true
  def handle_demand(_incoming_demand, :state_doesnt_matter) do
    # we don't care about demand b/c we are letting GenStage deal with it
    {:noreply, [], :state_doesnt_matter}
  end
end
