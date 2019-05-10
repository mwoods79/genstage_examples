defmodule GenstageExample.GenstageSupervisor do
  use Supervisor

  def start_link(_options) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      # GenstageExample.BasicProducer,
      # GenstageExample.QueueProducer,
      GenstageExample.DatabaseProducer,
      # GenstageExample.Consumer
      GenstageExample.WorkerPool
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

