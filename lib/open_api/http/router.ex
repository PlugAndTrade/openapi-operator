defmodule OpenAPI.HTTP.Router do
  use Plug.Router
  use Plug.ErrorHandler


  plug Plug.Static,
    at: "/",
    from: {:open_api, "priv/static"}

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_file(conn, 200, "priv/static/index.html")
  end

  get "/swagger.json" do
    send_file(conn, 200, "priv/static/swagger.json")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
