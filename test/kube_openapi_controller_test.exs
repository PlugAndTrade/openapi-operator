defmodule OpenAPITest do
  use ExUnit.Case
  doctest OpenAPI

  test "greets the world" do
    assert OpenAPI.hello() == :world
  end
end
