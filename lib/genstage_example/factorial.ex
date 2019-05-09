defmodule GenstageExample.Factorial do
  def find(1), do: 1

  def find(number) when is_integer(number) and number > 0 do
    number * find(number - 1)
  end

  def find(number) do
    raise "Error #{number} is not a positive integer"
  end
end
