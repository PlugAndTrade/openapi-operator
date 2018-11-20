defmodule OpenAPI do
  use Application
  require Logger

  @boot_msg "[OpenAPI documentation controller] started"

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Logger.info(fn -> "#{@boot_msg}" end)

    conn =
      :open_api
      |> Confex.fetch_env!(:k8s)
      |> configure()

    children = [
      OpenAPI.Controller.child_spec([
        conn,
        []
      ]),
      {OpenAPI.Specs, []},
      {OpenAPI.HTTP.Supervisor, port: 4000}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: OpenAPI.Supervisor)
  end

  defp configure(conf), do: do_configure(conf[:mode], conf)
  defp do_configure(:proxy, conf), do: %Kazan.Server{url: Keyword.fetch!(conf, :api_server)}
  defp do_configure(:in_cluster, _conf), do: Kazan.Server.in_cluster()
end
