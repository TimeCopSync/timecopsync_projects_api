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
end
