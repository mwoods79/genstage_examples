defmodule GenstageExample.Router do
  use Plug.Router

  alias GenstageExample.{Factorial}

  plug :match

  plug Plug.Parsers, parsers: [:urlencoded]

  plug :dispatch

  get "/factorial" do
    if number = conn.params["number"] do
      # GenstageExample.BasicProducer.add({Factorial, :find, [String.to_integer(number)]})
      # GenstageExample.QueueProducer.add({Factorial, :find, [String.to_integer(number)]})

      Enum.each(0..1000, fn _i -> GenstageExample.DatabaseProducer.add({Factorial, :find, [String.to_integer(number)*1000]}) end)
      send_resp(conn, 202, "work added to queue")
    else
      send_resp(conn, 422, "must include a number")
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
