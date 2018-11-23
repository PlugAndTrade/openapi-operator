defmodule OpenAPI.Template.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, opts)
  end

  def init(opts) do
    Logger.info("#{__MODULE__} :: opts #{inspect opts}")
    {file, params} = Keyword.pop(opts, :file)

    children = [
      {OpenAPI.Template.Renderer, [file: file, params: params]},
      {OpenAPI.Template.Inject, [["info", "description"]]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
