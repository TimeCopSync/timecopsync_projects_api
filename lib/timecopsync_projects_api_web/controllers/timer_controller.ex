defmodule TimecopsyncProjectsApiWeb.TimerController do
  use TimecopsyncProjectsApiWeb, :controller

  alias TimecopsyncProjectsApi.Projects
  alias TimecopsyncProjectsApi.Projects.Timer

  use PhoenixSwagger

  action_fallback TimecopsyncProjectsApiWeb.FallbackController

  swagger_path :index do
    get("/timers")
    description("List timers")

    response(200, "Success", Schema.ref(:Timers))
  end

  def index(conn, _params) do
    timers = Projects.list_timers()
    render(conn, :index, timers: timers)
  end

  swagger_path :create do
    post("/timers")
    description("Create a new timer")

    parameters do
      body(:body, Schema.ref(:TimerInput), "Timer to create", required: true)
    end

    response(201, "Created", Schema.ref(:TimerResponse))
    response(400, "Bad request")
  end

  def create(conn, %{"timer" => timer_params}) do
    with {:ok, %Timer{} = timer} <- Projects.create_timer(timer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/timers/#{timer}")
      |> render(:show, timer: timer)
    end
  end

  swagger_path :show do
    get("/timers/{id}")
    description("Get a single timer")

    parameters do
      id(:path, :string, "Timer ID", required: true)
    end

    response(200, "Success", Schema.ref(:TimerResponse))
    response(404, "Not found")
  end

  def show(conn, %{"id" => id}) do
    timer = Projects.get_timer!(id)
    render(conn, :show, timer: timer)
  end

  swagger_path :update do
    patch("/timers/{id}")
    description("Update a timer")

    parameters do
      id(:path, :string, "Timer ID", required: true)
      body(:body, Schema.ref(:TimerInput), "Timer to update", required: true)
    end

    response(200, "Success", Schema.ref(:TimerResponse))
    response(404, "Not found")
    response(400, "Bad request")
  end

  def update(conn, %{"id" => id, "timer" => timer_params}) do
    timer = Projects.get_timer!(id)

    with {:ok, %Timer{} = timer} <- Projects.update_timer(timer, timer_params) do
      render(conn, :show, timer: timer)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/timers/{id}")
    description("Delete a timer")

    parameters do
      id(:path, :string, "Timer ID", required: true)
    end

    response(204, "No content")
    response(404, "Not found")
  end

  def delete(conn, %{"id" => id}) do
    timer = Projects.get_timer!(id)

    with {:ok, %Timer{}} <- Projects.delete_timer(timer) do
      send_resp(conn, :no_content, "")
    end
  end

  def swagger_definitions do
    %{
      Timer:
        swagger_schema do
          title("Timer")

          description(
            "Timer object, represents time spend on a Task. One timer might belong to a Project"
          )

          properties do
            id(:string, "Timer ID")
            description(:string, "Description of the timer")
            notes(:string, "Notes about the timer, in markdown format")
            start_time(:string, "Start time of the timer in UTC format", required: true)

            end_time(
              :string,
              "End time of the timer in UTC format, a timer cannot end before it started. If not provided, timer is still running"
            )

            project_id(:string, "Project ID this timer belongs to")
          end

          example(%{
            id: "123e4567-e89b-12d3-a456-426614174000",
            description: "Working on the new feature",
            notes: "> This is a highly important task",
            start_time: "2020-01-01T12:00:00Z",
            end_time: "2020-01-01T13:00:00Z",
            project_id: "0f9ce9be-a720-41df-83bc-ad6ccb4738ec"
          })
        end,
      TimerInput:
        swagger_schema do
          title("Timer Input")

          description(
            "A timer represents time spend on a Task. Use this schema for creating or updating a timer"
          )

          property(
            :timer,
            Schema.new do
              properties do
                description(:string, "Description of the timer")
                notes(:string, "Notes about the timer, in markdown format")
                start_time(:string, "Start time of the timer in UTC format", required: true)

                end_time(
                  :string,
                  "End time of the timer in UTC format, a timer cannot end before it started. If not provided, timer is still running"
                )

                project_id(:string, "Project ID this timer belongs to")
              end
            end,
            "Timer object",
            required: true
          )

          example(%{
            timer: %{
              description: "Working on the new feature",
              notes: "> This is a highly important task",
              start_time: "2020-01-01T12:00:00Z",
              end_time: "2020-01-01T13:00:00Z",
              project_id: "0f9ce9be-a720-41df-83bc-ad6ccb4738ec"
            }
          })
        end,
      Timers:
        swagger_schema do
          title("Timers")
          description("A collection of timers")

          properties do
            metadata(
              Schema.new do
                properties do
                  total(:integer, "Total number of projects")
                  #              page :integer, "Current page"
                  #              per_page :integer, "Number of projects per page"
                end
              end
            )

            data(Schema.array(:Timer))
          end

          example(%{
            metadata: %{total: 1},
            data: [
              %{
                id: "123e4567-e89b-12d3-a456-426614174000",
                description: "Working on the new feature",
                notes: "> This is a highly important task",
                start_time: "2020-01-01T12:00:00Z",
                end_time: "2020-01-01T13:00:00Z",
                project_id: "0f9ce9be-a720-41df-83bc-ad6ccb4738ec"
              }
            ]
          })
        end,
      TimerResponse:
        swagger_schema do
          title("Timer Response")
          property(:data, Schema.ref(:Timer), "response data")
        end
    }
  end
end
