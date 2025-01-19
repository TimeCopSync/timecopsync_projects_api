defmodule TimecopsyncProjectsApi.Health do
  @moduledoc """
  Check various health attributes of the application
  """
  alias TimecopsyncProjectsApi.Projects.{Timer, Project}
  alias TimecopsyncProjectsApi.Repo

  @doc """
  Startup probe: has everything finished loading & starting ?
  """
  # because for now this is the only service in our app
  def has_started?, do: is_alive?()

  @doc """
  Liveness probe: is everything still working?
  """
  def is_alive?, do: Repo.exists?(Project) && Repo.exists?(Timer)
end
