defmodule OpenAPI.Specs do
  use Agent
  alias OpenAPI.Spec

  def start_link(_) do
    Agent.start_link(fn -> Map.new() end, name: __MODULE__)
  end

  def put_spec(%Spec{} = s) do
    Agent.update(__MODULE__, &Map.put(&1, Spec.fqdn(s), s))
  end

  def get_spec(name, ns) do
    name
    |> Spec.fqdn(ns)
    |> get_spec()
  end

  def get_spec(fqdn) do
    Agent.get(__MODULE__, &Map.get(&1, fqdn))
  end

  def has?(fqdn) do
    Agent.get(__MODULE__, &Map.has_key?(&1, fqdn))
  end

  def remove_spec(%Spec{} = s) do
    remove_spec(Spec.fqdn(s))
  end

  def remove_spec(fqdn) do
    Agent.get_and_update(__MODULE__, fn state ->
      Map.pop(state, fqdn)
    end)
  end

  def take_all() do
    Agent.get(__MODULE__, &Map.values/1)
  end
end
