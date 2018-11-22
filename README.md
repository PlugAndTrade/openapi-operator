# OpenAPI Operator

**TODO: Add description**

Merges `swagger` definitions based on service annotations. K8s services with the `swagger.io/docs` annotation set
are merged with a base template. The UI is rendered using [ReDoc](https://github.com/Rebilly/ReDoc)

## Configure targets
Swagger docs are based on annotations the following annotations are available:

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

