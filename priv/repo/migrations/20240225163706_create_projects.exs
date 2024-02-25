defmodule TimecopsyncProjectsApi.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :colour, :integer
      add :archived, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
