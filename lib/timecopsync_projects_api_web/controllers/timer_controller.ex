defmodule TimecopsyncProjectsApiWeb.TimerController do
  use TimecopsyncProjectsApiWeb, :controller

  alias TimecopsyncProjectsApi.Projects
  alias TimecopsyncProjectsApi.Projects.Timer

  action_fallback TimecopsyncProjectsApiWeb.FallbackController

  def index(conn, _params) do
    timers = Projects.list_timers()
    render(conn, :index, timers: timers)
  end

  def create(conn, %{"timer" => timer_params}) do
    with {:ok, %Timer{} = timer} <- Projects.create_timer(timer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/timers/#{timer}")
      |> render(:show, timer: timer)
    end
  end

  def show(conn, %{"id" => id}) do
    timer = Projects.get_timer!(id)
    render(conn, :show, timer: timer)
  end

  def update(conn, %{"id" => id, "timer" => timer_params}) do
    timer = Projects.get_timer!(id)

    with {:ok, %Timer{} = timer} <- Projects.update_timer(timer, timer_params) do
      render(conn, :show, timer: timer)
    end
  end

  def delete(conn, %{"id" => id}) do
    timer = Projects.get_timer!(id)

    with {:ok, %Timer{}} <- Projects.delete_timer(timer) do
      send_resp(conn, :no_content, "")
    end
  end
end
