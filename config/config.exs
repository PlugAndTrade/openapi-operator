# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :open_api, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:open_api, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"

config :open_api,
  k8s: [
    api_server: {:system, "K8S_API_SERVER", "http://localhost:8001"},
    mode: {:system, :atom, "K8S_MODE", :proxy}
  ],
  template: [
    file: {:system, "TEMPLATE_FILE_PATH", "priv/templates/base.yaml.eex"},
    title: {:system, "OPEN_API_TEMPLATE_TITLE", "OpenAPI Example"},
    host: {:system, "OPEN_API_TEMPLATE_HOST", "api-openapi.example.com"},
    base_path: {:system, "OPEN_API_TEMPLATE_BASEPATH", "/"},
    version: {:system, "OPEN_API_TEMPLATE_VERSION", "v1"},
    x_logo_url: {:system, "OPEN_API_TEMPLATE_LOG_URL", "http://plug-n-trade.com/img/about/pnt_ampersand.png"}
  ]
