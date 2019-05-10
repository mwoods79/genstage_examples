defmodule GenstageExample.Database do
  import Ecto.Query

  alias GenstageExample.Repo

  def take_tasks(limit) do
    {:ok, {count, events}} =
      Repo.transaction(fn ->
        ids = Repo.all(waiting(limit))

        {count, nil} =
          Repo.update_all(by_ids(ids), [set: [status: "running"]], returning: [:id, :payload])

        events = Repo.all(processing(by_ids(ids)))
        {count, events}
      end)

    {count, events}
  end

  def insert_task(payload) do
    Repo.insert_all("tasks", [
      %{status: "waiting", payload: payload}
    ])
  end

  def update_task_status(id, status) do
    Repo.update_all(by_ids([id]), set: [status: status])
  end

  defp by_ids(ids) do
    from(t in "tasks", where: t.id in ^ids)
  end

  defp processing(tasks) do
    from(t in tasks, select: t.payload)
  end

  defp waiting(limit) do
    from(t in "tasks",
      where: t.status == "waiting",
      limit: ^limit,
      select: t.id,
      lock: "FOR UPDATE SKIP LOCKED"
    )
  end
end
