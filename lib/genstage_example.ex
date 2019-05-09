defmodule GenstageExample do
  alias GenstageExample.{BasicProducer}

  def enqueue({m, f, a}) do
    BasicProducer.add({m, f, a})
  end
end
