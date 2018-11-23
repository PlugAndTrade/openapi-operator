defmodule OpenAPI.TemplateTest do
  use ExUnit.Case, async: true

  alias OpenAPI.Template

  setup do

    {file, params} = :open_api
      |> Confex.fetch_env!(:template)
      |> Keyword.pop(:file)

    t = Template.from_file(file, params)

    {:ok, %{template: t}}
  end

  describe "cout/2" do
    test "returns the compiled template as a map", %{template: %Template{cout: cout}} do
      assert %{"info" => %{"version" => version}} = cout
      assert version == "v1"
    end
  end

  describe "inject/3" do
    test "can inject a template in the provided path", %{template: template} do
      assert %Template{templates: ts, cout: cout} =
               Template.inject(template, {["info", "version"], "<%= my_template %>"})

      assert length(ts) > 0
      assert %{"info" => %{"version" => version}} = cout
      assert String.contains?(version, "<%= my_template %>")
    end

    test "returns nil if the provided path does not exist in the template", %{template: template} do
      assert template |> Template.inject({["does", "not", "exist"], "<%= version %>"}) |> is_nil
    end
  end

  describe "compile/2" do
    test "compiles any templates strings present", %{template: template} do
      path = ["info", "version"]
      t = Template.inject(template, {path, "<%= my_template %>"})

      %{"info" => %{"version" => version}} = Template.compile(t, my_template: "compiled")
      assert String.contains?(version, "compiled")
    end
  end
end
