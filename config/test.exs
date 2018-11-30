use Mix.Config

config :open_api,
  k8s: [
    api_server: {:system, "K8S_API_SERVER", "http://localhost:8001"},
    mode: {:system, :atom, "K8S_MODE", :proxy}
  ],
  template: [
    file: {:system, "OPEN_API_TEMPLATE_FILE_PATH", "priv/templates/base.yaml.eex"},
    title: {:system, "OPEN_API_TEMPLATE_TITLE", "OpenAPI Example"},
    host: {:system, "OPEN_API_TEMPLATE_HOST", "api-openapi.example.com"},
    base_path: {:system, "OPEN_API_TEMPLATE_BASEPATH", "/"},
    version: {:system, "OPEN_API_TEMPLATE_VERSION", "v1"},
    x_logo_url: {:system, "OPEN_API_TEMPLATE_LOGO_URL", "http://plug-n-trade.com/img/about/pnt_ampersand.png"}
  ]
