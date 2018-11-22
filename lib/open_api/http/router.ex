defmodule OpenAPI.HTTP.Router do
  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  alias OpenAPI.HTTP.Render
  alias OpenAPI.{Spec, Specs, Proxy}

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> Plug.Conn.send_resp(200, Render.base("title", "/swagger.json"))
  end

  get "/api/:fqdn" do
    case Specs.get_spec(fqdn) do
      nil ->
        send_resp(conn, 404, "Not found")

      %Spec{name: name} ->
        conn
        |> Plug.Conn.put_resp_content_type("text/html")
        |> Plug.Conn.send_resp(200, Render.base("#{name}", "/#{fqdn}/swagger.json"))
    end
  end

  get "/swagger.json" do
    body =
      [
        apis: Enum.map(Specs.take_all(), &{Spec.name(&1), "/#{Spec.fqdn(&1)}/swagger.json"})
      ]
      |> OpenAPI.Template.Renderer.compile()
      |> Poison.encode!()

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(200, body)
  end

  get "/:fqdn/swagger.json" do
    with %Spec{} = s <- Specs.get_spec(fqdn),
         {:ok, body} <- Proxy.request(s) do
      conn
      |> Plug.Conn.put_resp_content_type("application/json")
      |> Plug.Conn.send_resp(200, body)
    else
      nil ->
        send_resp(conn, 404, "Not found")

      {:error, reason} ->
        Logger.error("#{__MODULE__} :: Proxy to #{fqdn} Swagger docs failed with: #{reason}")
        send_resp(conn, 500, "Error #{inspect(reason)}")
    end
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
