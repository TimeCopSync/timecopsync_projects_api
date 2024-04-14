defmodule TimecopsyncProjectsApi.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias TimecopsyncProjectsApi.Repo

  alias TimecopsyncProjectsApi.Projects.Project

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  ## Parameters

  query_opts is a keyword list that can contain the following

  - `:limit` The maximum number of projects to return
  - `:show_archived` Whether to include archived projects

  """
  def list_projects(query_opts \\ []) do
    Repo.all(
      from p in Project,
        order_by: [asc: p.name],
        # Because we show not archived projects, always
        where: p.archived == false or p.archived == ^Keyword.get(query_opts, :show_archived, false),
        limit: ^Keyword.get(query_opts, :limit, 100)
    )
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Gets a single project and returns it in a ok tuple. returns an error tuple if the project does not exist.

  ## Examples

      iex> get_project(123)
      {:ok, %Project{}}

      iex> get_project(456)
      {:error, "Project not found"}

  """
  @spec get_project(Ecto.UUID.t() | String.t()) :: {:error, String.t()}  | {:ok, any()}
  def get_project(id) do
    case Repo.get(Project, id) do
      p when p != nil -> {:ok, p}
      _ -> {:error, "Project not found"}
    end
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end

  alias TimecopsyncProjectsApi.Projects.Timer

  @doc """
  Returns the list of timers.

  ## Examples

      iex> list_timers()
      [%Timer{}, ...]

  """
  def list_timers do
    Repo.all(Timer)
  end

  @doc """
  Gets a single timer.

  Raises `Ecto.NoResultsError` if the Timer does not exist.

  ## Examples

      iex> get_timer!(123)
      %Timer{}

      iex> get_timer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_timer!(id), do: Repo.get!(Timer, id)

  @doc """
  Gets a single timer and returns it in a ok tuple. returns an error tuple if the timer does not exist.

  ## Examples

      iex> get_timer(123)
      {:ok, %Timer{}}

      iex> get_timer(456)
      {:error, "Timer not found"}

  """
  @spec get_timer(Ecto.UUID.t() | String.t()) :: {:error, String.t()}  | {:ok, any()}
  def get_timer(id) do
    case Repo.get(Timer, id) do
      t when t != nil -> {:ok, t}
      _ -> {:error, "Timer not found"}
    end
  end

  @doc """
  Creates a timer.

  ## Examples

      iex> create_timer(%{field: value})
      {:ok, %Timer{}}

      iex> create_timer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timer(attrs \\ %{}) do
    %Timer{}
    |> Timer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a timer.

  ## Examples

      iex> update_timer(timer, %{field: new_value})
      {:ok, %Timer{}}

      iex> update_timer(timer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_timer(%Timer{} = timer, attrs) do
    timer
    |> Timer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a timer.

  ## Examples

      iex> delete_timer(timer)
      {:ok, %Timer{}}

      iex> delete_timer(timer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_timer(%Timer{} = timer) do
    Repo.delete(timer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking timer changes.

  ## Examples

      iex> change_timer(timer)
      %Ecto.Changeset{data: %Timer{}}

  """
  def change_timer(%Timer{} = timer, attrs \\ %{}) do
    Timer.changeset(timer, attrs)
  end
end
