defmodule TimecopsyncProjectsApi.Repo.Migrations.CreateTimers do
  use Ecto.Migration

  def change do
    create table(:timers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :notes, :string
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :project_id, references(:projects, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:timers, [:project_id])
  end
end
