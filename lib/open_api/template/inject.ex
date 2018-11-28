defmodule OpenAPI.Template.Inject do
  use Task
  require Logger

  @template "# APIS <%= for {name, fqdn} <- apis do %>\n## <%= name %>\n[<%= name %>](<%= fqdn %>)<% end %>"

  def start_link(opts \\ []) do
    Task.start_link(__MODULE__, :run, [opts])
  end

  def run([path]) do
    :ok = OpenAPI.Template.Renderer.inject(path, @template, "")
    Logger.info(fn -> "#{__MODULE__} :: Base template injected with: #{inspect @template, pretty: true}" end)
  end
end
