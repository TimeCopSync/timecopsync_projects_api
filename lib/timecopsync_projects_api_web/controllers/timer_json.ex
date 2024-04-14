defmodule TimecopsyncProjectsApiWeb.TimerJSON do
  alias TimecopsyncProjectsApi.Projects.Timer

  @doc """
  Renders a list of timers.
  """
  def index(%{timers: timers}) do
    %{
      metadata: %{
        total: length(timers)
        # page: page,
      },
      data: for(timer <- timers, do: data(timer))
    }
  end

  @doc """
  Renders a single timer.
  """
  def show(%{timer: timer}) do
    %{data: data(timer)}
  end

  defp data(%Timer{} = timer) do
    %{
      id: timer.id,
      description: timer.description,
      notes: timer.notes,
      start_time: timer.start_time,
      end_time: timer.end_time
    }
  end
end
