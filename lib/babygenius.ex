defmodule Babygenius do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Babygenius.Repo, []),
      # Start the endpoint when the application starts
      supervisor(BabygeniusWeb.Endpoint, []),
      # Supervise the FetchTimezone job
      supervisor(Task.Supervisor, [[name: Babygenius.TaskSupervisor, restart: :transient]])
      # Start your own worker by calling: Babygenius.Worker.start_link(arg1, arg2, arg3)
      # worker(Babygenius.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Babygenius.Supervisor]

    :ok = :error_logger.add_report_handler(Sentry.Logger)

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BabygeniusWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
