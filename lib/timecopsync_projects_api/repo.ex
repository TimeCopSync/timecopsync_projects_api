defmodule TimecopsyncProjectsApi.Repo do
  use Ecto.Repo,
    otp_app: :timecopsync_projects_api,
    adapter: Ecto.Adapters.Postgres
end
