defmodule OpenAPI.Spec.Annotations do
  alias OpenAPI.Spec.Types

  @prefix Types.prefix()
  @annotation_keys Types.keys()

  def parse(prefix, keys, annotations) do
    parse_annotation = fn key ->
      full_key = "#{prefix}/#{key}"

      value =
        annotations
        |> Map.get(full_key, nil)
        |> (&parse_value(full_key, &1)).()

      {String.to_atom(key), value}
    end

    is_defined? = fn
      {_k, nil} -> false
      {_k, _value} -> true
    end

    keys
    |> Enum.map(parse_annotation)
    |> Enum.filter(is_defined?)
    |> Enum.into(%{})
  end

  def parse_value(_field, nil), do: nil
  def parse_value("#{@prefix}/docs", value), do: String.to_existing_atom(value)
  def parse_value("#{@prefix}/port", value), do: String.to_integer(value)
  def parse_value("#{@prefix}/version", value), do: value
  def parse_value("#{@prefix}/path", value), do: value
end
