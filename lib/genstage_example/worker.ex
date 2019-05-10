defmodule GenstageExample.Worker do
  use Task

  def start_link({_m, _f, _a} = mfa) do
    Task.start_link(__MODULE__, :run, [mfa])
  end

  def run({m, f, a}) do
    apply(m, f, a)
    # |> IO.inspect(label: "#{inspect(self())} completed")
  end
end
