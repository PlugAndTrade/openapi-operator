defmodule OpenAPI.Template.Renderer do
  use Agent
  alias OpenAPI.Template

  def start_link(opts) do
    file = Keyword.fetch!(opts, :file)
    params = Keyword.fetch!(opts, :params)

    Agent.start_link(fn -> Template.from_file(file, params) end, name: __MODULE__)
  end

  def inject(path, template, delimiter \\ "\n") do
    Agent.update(__MODULE__, &Template.inject(&1, {path, template}, delimiter))
  end

  def compile(params) do
    Agent.get(__MODULE__, &Template.compile(&1, params))
  end

  def persist(params) do
    Agent.update(__MODULE__, &Template.persist(&1, params))
  end
end
