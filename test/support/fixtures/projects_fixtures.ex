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
end
