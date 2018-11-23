defmodule OpenAPI.MixProject do
  use Mix.Project

  def project do
    [
      app: :open_api,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {OpenAPI, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kazan, "~> 0.10"},
      {:confex, "~> 3.3.1"},
      {:yaml_elixir, "~> 2.1.0"},
      {:poison, "~> 4.0.1"},
      {:httpoison, "~> 1.4"},
      {:netex,
       git: "https://github.com/drowzy/netex", ref: "050b4226d0aab068b0a5eef4158ba1c9303c73ac"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.0"},
      {:distillery, "~> 2.0", runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
