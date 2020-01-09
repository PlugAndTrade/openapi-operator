# OpenAPI Operator

A OpenAPI (swagger) spec combiner for kubernetes

Finds specs by finding k8s services with the `swagger.io/docs` annotation set.
Service urls are injected into a base template as a markdown list. Requests for
a specific specification is reverse proxied to the target. The UI is rendered using [ReDoc](https://github.com/Rebilly/ReDoc)

## Configure

The following environment variables are available to customize the template:

| Env                           | Description                                                                             | Values        |
| -------------                 | :-------------:                                                                         | -----:        |
| `OPEN_API_TEMPLATE_FILE_PATH` | Path to a `swagger.yaml` to use a base template. default `priv/templates/base.yaml.eex` | `<file_path>` |
| `OPEN_API_TEMPLATE_TITLE`     | Base template title. default: `OpenAPI example`                                         | `<string>`    |
| `OPEN_API_TEMPLATE_HOST`      | Base template host. default `api-openapi.example.com`                                   | `<string>`    |
| `OPEN_API_TEMPLATE_BASEPATH`  | Base template basepath. default `/`                                                     | `<url_path>`  |
| `OPEN_API_TEMPLATE_LOGO_URL`  | Logo url. default `http://plug-n-trade.com/img/about/pnt_ampersand.png`                 | `<url>`       |
| `OPEN_API_TEMPLATE_VERSION`   | Base template API version. default `v1`                                                 | `<string>`    |

The following environment variables are available for runtime configuration:

## Base Template

The base template is the root Open API document, it serves as a landing page for all collected Open API specifications.
It is customizable, but it is recommended to override it with your own template.

The controller listens for changes to any k8s services which has the annotation:

```yaml
  swagger.io/docs: true
```

Based on the annotation the Open API document is collected and a link is injected at the bottom of the base template (bottom of `info.description`).
The hyperlink proxies the service documentation and rendered by the controller.  Any requests performed will be proxied as well.

## Configure targets
| ## Configure targets |

| Annotation             | Description                                    | Values        |
| -------------          | :-------------:                                | -----:        |
| `"swagger.io/docs"`    | If the service has swagger docs                | `true, false` |
| `"swagger.io/path"`    | Http path. default: `/swagger/v2/swagger.json` | `<string>`    |
| `"swagger.io/version"` | Swagger version. default `v2`                  | `<string>`    |
| `"swagger.io/port"`    | Http port. default `80`                        | `<int>`       |

## Developing

### Prerequisites
* [minikube](https://kubernetes.io/docs/setup/minikube/)
* [Erlang & Elixir](https://elixir-lang.org/install.html)

Minikube or other K8s environment needed.

* Intall dependencies

```
mix deps.get
```

* Compile

```
mix compile
```

* Running

`iex -S mix`
