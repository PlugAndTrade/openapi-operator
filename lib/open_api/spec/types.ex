defmodule OpenAPI.Spec.Types do
  @prefix "swagger.io"
  @annotation_keys ~w(port path version docs)

  def prefix, do: @prefix
  def keys, do: @annotation_keys
end
