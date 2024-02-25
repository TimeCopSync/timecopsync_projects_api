defmodule TimecopsyncProjectsApiWeb.ProjectController do
  use TimecopsyncProjectsApiWeb, :controller
  # alias TimecopsyncProjectsApiWeb

  alias TimecopsyncProjectsApi.Projects
  alias TimecopsyncProjectsApi.Projects.Project

  action_fallback TimecopsyncProjectsApiWeb.FallbackController

  def index(conn, params) do
    projects = Projects.list_projects(Keyword.get_and_update(
      Enum.map(params, &{String.to_existing_atom(elem(&1,0)), elem(&1,1)}),
      :show_archived,
      fn v -> {v, v in [true, "true", "TRUE", 1]} end
    ) |> elem(1))

    render(conn, :index, projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- Projects.create_project(project_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/projects/#{project}")
      |> render(:show, project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Projects.get_project!(id)
    render(conn, :show, project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Projects.get_project!(id)

    with {:ok, %Project{} = project} <- Projects.update_project(project, project_params) do
      render(conn, :show, project: project)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Projects.get_project!(id)

    with {:ok, %Project{}} <- Projects.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end
end
