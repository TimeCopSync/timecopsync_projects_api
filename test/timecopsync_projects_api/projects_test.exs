defmodule TimecopsyncProjectsApi.ProjectsTest do
  use TimecopsyncProjectsApi.DataCase

  alias TimecopsyncProjectsApi.Projects

  describe "projects" do
    alias TimecopsyncProjectsApi.Projects.Project

    import TimecopsyncProjectsApi.ProjectsFixtures

    @invalid_attrs %{name: nil, colour: 9999999999999999999, archived: nil}

    test "list_projects/1 w/o params returns all projects" do
      project = project_fixture()
      assert Projects.list_projects() == [project]
    end

    test "list_projects/1 returns all projects, including archived ones" do
      project = project_fixture()
      project2 = project_fixture(%{archived: true})
      assert Projects.list_projects(show_archived: true) == [project, project2]
    end

    test "list_projects/1 returns a set number of projects" do
      project = project_fixture()
      project2 = project_fixture()
      project3 = project_fixture()
      _project4 = project_fixture()
      _project5 = project_fixture()

      assert Projects.list_projects(limit: 3) == [project, project2, project3]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{name: "some name", colour: 42, archived: true}

      assert {:ok, %Project{} = project} = Projects.create_project(valid_attrs)
      assert project.name == "some name"
      assert project.colour == 42
      assert project.archived == true
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{name: "some updated name", colour: 43, archived: false}

      assert {:ok, %Project{} = project} = Projects.update_project(project, update_attrs)
      assert project.name == "some updated name"
      assert project.colour == 43
      assert project.archived == false
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end

  describe "timers" do
    alias TimecopsyncProjectsApi.Projects.Timer

    import TimecopsyncProjectsApi.ProjectsFixtures

    @invalid_attrs %{description: nil, notes: nil, start_time: nil, end_time: nil}

    test "list_timers/0 returns all timers" do
      timer = timer_fixture()
      assert Projects.list_timers() == [timer]
    end

    test "get_timer!/1 returns the timer with given id" do
      timer = timer_fixture()
      assert Projects.get_timer!(timer.id) == timer
    end

    test "create_timer/1 with valid data creates a timer" do
      valid_attrs = %{description: "some description", notes: "some notes", start_time: ~U[2024-02-24 23:28:00Z], end_time: ~U[2024-02-24 23:28:00Z]}

      assert {:ok, %Timer{} = timer} = Projects.create_timer(valid_attrs)
      assert timer.description == "some description"
      assert timer.notes == "some notes"
      assert timer.start_time == ~U[2024-02-24 23:28:00Z]
      assert timer.end_time == ~U[2024-02-24 23:28:00Z]
    end

    test "create_timer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_timer(@invalid_attrs)
    end

    test "update_timer/2 with valid data updates the timer" do
      timer = timer_fixture()
      update_attrs = %{description: "some updated description", notes: "some updated notes", start_time: ~U[2024-02-25 23:28:00Z], end_time: ~U[2024-02-25 23:28:00Z]}

      assert {:ok, %Timer{} = timer} = Projects.update_timer(timer, update_attrs)
      assert timer.description == "some updated description"
      assert timer.notes == "some updated notes"
      assert timer.start_time == ~U[2024-02-25 23:28:00Z]
      assert timer.end_time == ~U[2024-02-25 23:28:00Z]
    end

    test "update_timer/2 with invalid data returns error changeset" do
      timer = timer_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_timer(timer, @invalid_attrs)
      assert timer == Projects.get_timer!(timer.id)
    end

    test "delete_timer/1 deletes the timer" do
      timer = timer_fixture()
      assert {:ok, %Timer{}} = Projects.delete_timer(timer)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_timer!(timer.id) end
    end

    test "change_timer/1 returns a timer changeset" do
      timer = timer_fixture()
      assert %Ecto.Changeset{} = Projects.change_timer(timer)
    end
  end
end
