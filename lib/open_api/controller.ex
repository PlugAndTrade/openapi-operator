defmodule OpenAPI.Controller do
  use Netex.Controller
  require Logger

  alias Kazan.Watcher
  alias Kazan.Apis.Core.V1.{Service, ServiceList}
  alias Kazan.Models.Apimachinery.Meta.V1.ObjectMeta
  alias OpenAPI.{Spec, Specs}

  @impl true
  def init(opts) do
    Logger.info(fn -> "[#{__MODULE__}] :: K8s controller up!" end, ansi_color: :magenta)

    {:ok,
     %{
       conn: Keyword.fetch!(opts, :conn)
     }}
  end

  @impl true
  def watch_fn(_resource, _opts \\ []) do
    Kazan.Apis.Core.V1.watch_service_list_for_all_namespaces!()
  end

  @impl true
  def list_fn(opts \\ [])

  def list_fn(_config) do
    Kazan.Apis.Core.V1.list_service_for_all_namespaces!()
  end

  @impl true
  def handle_added(%Watcher.Event{object: object}, state) do
    _res = if Spec.is_target?(object), do: handle(:added, object, state), else: :ok
    state
  end

  @impl true
  def handle_modified(%Watcher.Event{object: object}, state) do
    _res = if Spec.is_target?(object), do: handle(:modified, object, state), else: :ok
    state
  end

  @impl true
  def handle_deleted(%Watcher.Event{object: object}, state) do
    _res = handle(:deleted, object, state)
    state
  end

  @impl true
  def handle_sync(%ServiceList{items: items}, state) do
    procs =
      items
      |> Enum.filter(&Spec.is_target?/1)
      |> Enum.map(&handle(:added, &1, state))

    Logger.debug(
      fn -> "[#{__MODULE__}] Synced OpenAPI enabled services. Got: #{length(procs)}" end,
      ansi_color: :blue
    )

    state
  end

  # Added/modfied is the same since we replace the entry in the store
  defp handle(:added, object, _state), do: handle(:modified, object, _state)

  defp handle(:modified, %Service{metadata: metadata} = object, _state) do
    Logger.debug(
      fn ->
        "[#{__MODULE__}] :: Service #{metadata.name}/#{metadata.namespace} modified / added"
      end,
      ansi_color: :blue
    )

    object
    |> Spec.new()
    |> Specs.put_spec()
  end

  defp handle(:deleted, %Service{metadata: metadata} = object, _state) do
    Logger.debug(
      fn ->
        "[#{__MODULE__}] :: #{metadata.name}/#{metadata.namespace} deleted. Attempt remove..."
      end,
      ansi_color: :blue
    )

    object
    |> Spec.new()
    |> Specs.remove_spec()
  end
end
