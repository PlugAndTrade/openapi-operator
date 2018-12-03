FROM elixir:1.7-alpine

RUN apk add --no-cache curl git build-base

RUN mkdir -p /app/open_api
WORKDIR /app/open_api

ADD mix.exs /app/open_api
ADD mix.lock /app/open_api
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile

ADD . /app/open_api/

ARG MIX_ENV=prod

RUN mix compile --env=prod && \
    mix release --env=prod

FROM alpine

RUN apk add --no-cache bash ncurses-libs libcrypto1.0 tzdata jq

RUN mkdir -p /open_api /tmp /etc/open_api /var/open_api/templates
WORKDIR /open_api

COPY --from=0 /app/open_api/_build/prod/rel/open_api/releases/latest/open_api.tar.gz /tmp/
COPY --from=0 /app/open_api/priv/templates/base.yaml.eex /var/open_api/templates/base.yaml.eex
RUN tar xvzf /tmp/open_api.tar.gz && rm -f /tmp/open_api.tar.gz

ENV REPLACE_OS_VARS true

CMD [ "/open_api/bin/open_api", "foreground" ]
