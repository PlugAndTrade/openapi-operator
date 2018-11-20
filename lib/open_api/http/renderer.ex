defmodule OpenAPI.HTTP.Render do
  require EEx

  EEx.function_from_file(:def, :base, Path.expand("./priv/templates/index.html.eex"), [
    :title,
    :url
  ])
end
