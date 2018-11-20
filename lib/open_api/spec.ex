defmodule OpenAPI.Spec do
  alias Kazan.Apis.Core.V1.Service
  alias Kazan.Models.Apimachinery.Meta.V1.ObjectMeta
  alias OpenAPI.Spec.Types
  alias OpenAPI.Spec

  @prefix Types.prefix()
  @annotation_keys Types.keys()

  defstruct [:metadata, :name, :path, :port, :version, :url]

  def new(%Service{metadata: %ObjectMeta{annotations: ann} = meta}) do
    conf =
      Map.new()
      |> Map.put(:metadata, meta)
      |> Map.merge(Spec.Annotations.parse(@prefix, @annotation_keys, ann))

    struct(Spec, conf)
  end

  def fqdn(%__MODULE__{metadata: %ObjectMeta{name: n, namespace: ns}}), do: fqdn(n, ns)

  def fqdn(name, namespace) when is_binary(name) and is_binary(namespace) do
    "#{name}.#{namespace}.svc.cluster.local"
  end

  def is_target?(%Service{metadata: %ObjectMeta{annotations: nil}}), do: false

  def is_target?(%Service{metadata: %ObjectMeta{annotations: annotations}}) do
    annotations
    |> Map.get("#{@prefix}/docs", "false")
    |> String.to_existing_atom()
    |> Kernel.==(true)
  end
end
