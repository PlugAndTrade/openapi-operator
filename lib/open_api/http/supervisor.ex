defmodule OpenAPI.HTTP.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, opts)
  end

  def init(opts) do
    port = Keyword.get(opts, :port, 4000)


    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: OpenAPI.HTTP.Router,
        options: [port: port, timeout: 70_000]
      )
    ]

    Logger.info(fn -> "[#{__MODULE__}] :: Starting HTTP server on port #{port}" end, ansi_color: :magenta)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
