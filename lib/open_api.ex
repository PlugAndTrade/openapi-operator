defmodule OpenAPI do
  use Application
  require Logger

  @boot_msg "[OpenAPI Operator] started"

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    k8s_conf = Confex.fetch_env!(:open_api, :k8s)
    template_conf = Confex.fetch_env!(:open_api, :template)
    conn = conn = configure(k8s_conf)

    children = [
      OpenAPI.Controller.child_spec([
        conn,
        []
      ]),
      {OpenAPI.Specs, []},
      {OpenAPI.HTTP.Supervisor, port: 4000},
      {OpenAPI.Template.Supervisor, template_conf}
    ]

    Logger.info(fn -> "#{@boot_msg}" end, ansi_color: :magenta)
    Logger.debug(fn -> "Kubernetes conf: #{inspect k8s_conf, pretty: true}" end, ansi_color: :green)
    Logger.debug(fn -> "Templating conf: #{inspect template_conf, pretty: true}" end, ansi_color: :green)

    Supervisor.start_link(children, strategy: :one_for_one, name: OpenAPI.Supervisor)
  end

  defp configure(conf), do: do_configure(conf[:mode], conf)
  defp do_configure(:proxy, conf), do: %Kazan.Server{url: Keyword.fetch!(conf, :api_server)}
  defp do_configure(:in_cluster, _conf), do: Kazan.Server.in_cluster()
end
