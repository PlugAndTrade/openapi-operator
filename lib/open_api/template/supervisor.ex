defmodule OpenAPI.Template.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, opts)
  end

  def init(opts) do
    children = [
      {OpenAPI.Template.Renderer,
       [file: "priv/templates/base.yaml.eex", params: [title: "api.host.se", host: "api.host.se"]]},
      {OpenAPI.Template.Inject, [["info", "description"]]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
