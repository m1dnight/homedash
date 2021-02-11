################################################################################
# Build Image
FROM elixir:alpine as build
LABEL maintainer "Christophe De Troyer <christophe@call-cc.be>"

# Install compile-time dependencies
RUN apk add --update git build-base nodejs npm yarn python3
RUN mkdir /app 
WORKDIR /app 

# Install Hex and Rebar 
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# Build web assets.
COPY assets assets
RUN cd assets && npm install && npm run deploy
RUN mix phx.digest

# Compile entire project.
COPY priv priv
COPY lib lib
RUN mix compile

# Build the entire release.
RUN mix release

################################################################################
# Release Image

FROM alpine:latest AS app

RUN apk add --update bash openssl postgresql-client
ENV MIX_ENV=prod

# Make the working directory for the application.
RUN mkdir /app
WORKDIR /app

# Copy release from build container to this container.
COPY --from=build /app/_build/prod/rel/homedash .
COPY entrypoint.sh .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD ["bash", "/app/entrypoint.sh"]