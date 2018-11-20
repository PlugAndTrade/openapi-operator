defmodule OpenAPI.Proxy do
  alias OpenAPI.Spec
  alias HTTPoison.{Response, Error}

  # TODO cache
  def request(%Spec{port: port} = s) do
    url = base_url(Spec.fqdn(s), port)

    case HTTPoison.get(url) do
      {:ok, %Response{body: body}} -> {:ok, body}
      {:error, %Error{reason: reason}} -> {:error, reason}
    end
  end

  defp base_url(host, port), do: host <> ":" <> port
end
