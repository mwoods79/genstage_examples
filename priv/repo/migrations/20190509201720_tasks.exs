defmodule GenstageExample.Repo.Migrations.Tasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add(:status, :text)
      add(:payload, :binary)
    end
  end
end
