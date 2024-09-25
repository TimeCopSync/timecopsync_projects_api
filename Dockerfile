ARG ELIXIR_VERSION=1.17.3
ARG OTP_VERSION=27.1
ARG ALPINE_VERSION=3.19.3

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-alpine-${ALPINE_VERSION}"
ARG RUNNER_IMAGE="alpine:${ALPINE_VERSION}"

FROM ${BUILDER_IMAGE} as builder
ENV MIX_ENV="prod"

WORKDIR /app

# install build tools
RUN mix local.hex --force && \
    mix local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# Copy files
COPY config/config.exs config/${MIX_ENV}.exs config/
COPY priv priv
COPY lib lib

# Compile then create binary
RUN mix compile
RUN mix release

COPY config/runtime.exs config/

FROM ${RUNNER_IMAGE}

# Set the locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/timecopsync_projects_api ./

USER nobody

CMD ["/app/bin/server"]