defmodule TimecopsyncProjectsApiWeb.ProjectController do
  use TimecopsyncProjectsApiWeb, :controller
  # alias TimecopsyncProjectsApiWeb

  alias TimecopsyncProjectsApi.Projects
  alias TimecopsyncProjectsApi.Projects.Project

  use PhoenixSwagger

  action_fallback TimecopsyncProjectsApiWeb.FallbackController

  swagger_path :index do
    get "/projects"
    description "List projects, fetches 100 unarchived projects by default"
    parameters do
      limit :query, :integer, "Number of results to show", example: 1000
      show_archived :query, :integer, "if 1 shows archived projects, defaults to 0", example: 1
    end

    response 200, "Success", Schema.ref(:Projects)
  end
  def index(conn, params) do
    projects = Projects.list_projects(Keyword.get_and_update(
      Enum.map(params, &{String.to_existing_atom(elem(&1,0)), elem(&1,1)}),
      :show_archived,
      fn v -> {v, v in [true, "true", "TRUE", 1]} end
    ) |> elem(1))

    render(conn, :index, projects: projects)
  end


  swagger_path :create do
    post "/projects"
    description "Create a new project"
    parameters do
      body :body, Schema.ref(:ProjectInput), "Project to create", required: true
    end

    response 201, "Created", Schema.ref(:ProjectResponse)
    response 400, "Bad request"
  end
  def create(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- Projects.create_project(project_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/projects/#{project}")
      |> render(:show, project: project)
    end
  end

  swagger_path :show do
    get "/projects/{id}"
    description "Get a single project"
    parameters do
      id :path, :string, "Project ID", required: true
    end

    response 200, "Success", Schema.ref(:ProjectResponse)
    response 404, "Not found"
  end
  def show(conn, %{"id" => id}) do
    project = Projects.get_project!(id)
    render(conn, :show, project: project)
  end

  swagger_path :update do
    patch "/projects/{id}"
    description "Update a project"
    parameters do
      id :path, :string, "Project ID", required: true
      body :body, Schema.ref(:ProjectInput), "Project to update", required: true
    end

    response 200, "Success", Schema.ref(:ProjectResponse)
    response 404, "Not found"
    response 400, "Bad request"
  end
  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Projects.get_project!(id)

    with {:ok, %Project{} = project} <- Projects.update_project(project, project_params) do
      render(conn, :show, project: project)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/projects/{id}"
    description "Delete a project"
    parameters do
      id :path, :string, "Project ID", required: true
    end

    response 204, "No content"
    response 404, "Not found"
  end
  def delete(conn, %{"id" => id}) do
    project = Projects.get_project!(id)

    with {:ok, %Project{}} <- Projects.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end

  def swagger_definitions do
    %{
      ProjectInput: swagger_schema do
        title "Project Input"
        description "A project consists of a collection of timers, use this schema for creating or updating a project"
        property :project, (Schema.new do
          properties do
            name :string, "Project name", required: true
            colour :integer, "Colour associated represented by hex values casted into integer"
            archived :boolean, "Archived status"
          end
        end), "Project object", required: true

        example %{
          project: %{
            name: "My awesome project!",
            colour: 16777215,
            archived: false
          }
        }
      end,
      Project: swagger_schema do
        title "Project"
        description "A project consists of a collection of timers"
        properties do
          id :string, "Project ID"
          name :string, "Project name", required: true
          colour :integer, "Colour associated represented by hex values casted into integer"
          archived :boolean, "Archived status"
        end
        example %{
          id: "0f9ce9be-a720-41df-83bc-ad6ccb4738ec",
          name: "My awesome project!",
          colour: 16777215,
          archived: false
        }
      end,
      Projects: swagger_schema do
        title "Projects"
        description "List of projects"
        properties do
          metadata (Schema.new do
            properties do
              total :integer, "Total number of projects"
#              page :integer, "Current page"
#              per_page :integer, "Number of projects per page"
            end
          end)
          data Schema.array(:Project)
        end
      end,
      ProjectResponse: swagger_schema do
        title "Projects Response"
        property :data, Schema.ref(:Project), "response data"
      end
    }
  end
end
