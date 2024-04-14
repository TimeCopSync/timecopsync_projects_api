defmodule TimecopsyncProjectsApi.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimecopsyncProjectsApi.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        archived: false,
        colour: 42,
        name: "some name"
      })
      |> TimecopsyncProjectsApi.Projects.create_project()

    project
  end

  @doc """
  Generate a timer.
  """
  def timer_fixture(attrs \\ %{}) do
    {:ok, timer} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_time: ~U[2024-02-24 23:28:00Z],
        notes: "some notes",
        start_time: ~U[2024-02-24 23:28:00Z]
      })
      |> TimecopsyncProjectsApi.Projects.create_timer()

    timer
  end
end
