defmodule TimecopsyncProjectsApi.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "projects" do
    field :name, :string
    field :colour, :integer
    field :archived, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :colour, :archived])
    |> validate_number(:colour, greater_than_or_equal_to: 0, less_than_or_equal_to: 16777216)
    |> validate_required([:name])
  end
end
