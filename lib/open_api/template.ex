defmodule OpenAPI.Template do
  require EEx
  require Logger

  alias OpenAPI.Template

  defstruct [:raw, :cout, :templates]

  def from_file(file, params) do
    compiled =
      file
      |> EEx.eval_file(params)
      |> YamlElixir.read_from_string!()

    %Template{
      cout: compiled,
      raw: {file, :file},
      templates: []
    }
  end

  def compile(template, params \\ [])

  def compile(%Template{templates: ts, cout: cout}, params) do
    ts
    |> Enum.map(fn {path, _} -> path end)
    |> Enum.reduce(cout, fn path, state ->
      Kernel.update_in(state, path, &EEx.eval_string(&1, params))
    end)
  end

  def persist(template, params \\ [])

  def persist(%Template{} = t, params) do
    %{t | cout: compile(t, params), templates: []}
  end

  def inject(t, inj, delimiter \\ "\n")

  def inject(%Template{cout: cout, templates: ts} = t, {in_, template} = inj, delimiter) do
    with value when not is_nil(value) <- Kernel.get_in(cout, in_),
         update_c <- Kernel.update_in(cout, in_, &(&1 <> delimiter <> template)) do
      %{t | cout: update_c, templates: [inj | ts]}
    else
      nil -> nil
    end
  end
end
