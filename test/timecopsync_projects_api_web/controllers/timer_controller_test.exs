defmodule TimecopsyncProjectsApiWeb.TimerControllerTest do
  use TimecopsyncProjectsApiWeb.ConnCase

  import TimecopsyncProjectsApi.ProjectsFixtures

  alias TimecopsyncProjectsApi.Projects.Timer

  @create_attrs %{
    description: "some description",
    notes: "some notes",
    start_time: ~U[2024-02-24 23:28:00Z],
    end_time: ~U[2024-02-24 23:28:00Z]
  }
  @update_attrs %{
    description: "some updated description",
    notes: "some updated notes",
    start_time: ~U[2024-02-25 23:28:00Z],
    end_time: ~U[2024-02-25 23:28:00Z]
  }
  @invalid_attrs %{description: nil, notes: nil, start_time: nil, end_time: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all timers", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/timers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create timer" do
    test "renders timer when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/timers", timer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/v1/timers/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "end_time" => "2024-02-24T23:28:00Z",
               "notes" => "some notes",
               "start_time" => "2024-02-24T23:28:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/timers", timer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update timer" do
    setup [:create_timer]

    test "renders timer when data is valid", %{conn: conn, timer: %Timer{id: id} = timer} do
      conn = put(conn, ~p"/api/v1/timers/#{timer}", timer: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/v1/timers/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "end_time" => "2024-02-25T23:28:00Z",
               "notes" => "some updated notes",
               "start_time" => "2024-02-25T23:28:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, timer: timer} do
      conn = put(conn, ~p"/api/v1/timers/#{timer}", timer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete timer" do
    setup [:create_timer]

    test "deletes chosen timer", %{conn: conn, timer: timer} do
      conn = delete(conn, ~p"/api/v1/timers/#{timer}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/timers/#{timer}")
      end
    end
  end

  defp create_timer(_) do
    timer = timer_fixture()
    %{timer: timer}
  end
end
