defmodule TimecopsyncProjectsApiWeb.Router do
  use TimecopsyncProjectsApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", TimecopsyncProjectsApiWeb do
    pipe_through :api

    resources "/projects", ProjectController, except: [:new, :edit]
    resources "/timers", TimerController, except: [:new, :edit]
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :timecopsync_projects_api, swagger_file: "swagger.json"
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:timecopsync_projects_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimecopsyncProjectsApiWeb.Telemetry
    end
  end

  def swagger_info do
    %{
      schemes: ["http", "https"],
      basePath: "/api/v1",
      info: %{
        version: "1.0",
        title: "TimeCopSync Projects API"
      }
    }
  end
end
