defmodule OpenAPI.Proxy do
  alias OpenAPI.Spec
  alias HTTPoison.{Response, Error}

  # TODO cache
  def request(%Spec{} = s) do
    req =
      s
      |> Spec.url()
      |> HTTPoison.get()

    case req do
      {:ok, %Response{body: body}} -> {:ok, body}
      {:error, %Error{reason: reason}} -> {:error, reason}
    end
  end
end
