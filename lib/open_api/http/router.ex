defmodule OpenAPI.HTTP.Router do
  use Plug.Router
  use Plug.ErrorHandler

  alias OpenAPI.HTTP.Render
  alias OpenAPI.{Spec, Specs}

  plug(Plug.Static,
    at: "/",
    from: {:open_api, "priv/static"}
  )

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
    send_file(conn, 200, "priv/static/swagger.json")
  end

  get "/:fqdn/swagger.json" do
    send_file(conn, 200, "priv/static/test.swagger.json")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
