defmodule TimecopsyncProjectsApi.Projects.Timer do
  use Ecto.Schema
  import Ecto.Changeset

  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "timers" do
    field :description, :string
    field :notes, :string
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :project_id, :binary_id

    timestamps(type: :utc_datetime)
  end


  defp check_chronology(_, ended) when is_nil(ended), do: :lt

  defp check_chronology(started, ended) do
    DateTime.compare(started, ended)
  end

  def validate_datetime_chronology(changeset) do
    start_time = get_field(changeset, :start_time)
    end_time = get_field(changeset, :end_time)

    case check_chronology(start_time, end_time) do
      :gt -> add_error(changeset, :end_time, "A timer cannot end before it started!")
      _ -> changeset
    end
  end

  @doc false
  def changeset(timer, attrs) do
    timer
    |> cast(attrs, [:description, :notes, :start_time, :end_time])
    |> validate_required([:start_time])
    |> validate_datetime_chronology()
  end
end
