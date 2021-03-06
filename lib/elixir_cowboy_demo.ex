defmodule ElixirCowboyDemo do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(ElixirCowboyDemo.Worker, [arg1, arg2, arg3]),
      worker(ElixirCowboyDemo, [], function: :run)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirCowboyDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def run do
    routes = [
      {"/", ElixirCowboyDemo.Root, []}
    ]

    dispatch = :cowboy_router.compile([{:_, routes}])

    opts = [port: 8000]
    env = [dispatch: dispatch]

    {:ok, _pid} = :cowboy.start_http(:http, 100, opts, [env: env])

  end

end
