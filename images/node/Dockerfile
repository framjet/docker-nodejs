ARG UPTRACK_SOURCE=node:alpine
ARG WAIT4X_VERSION=latest
FROM docker.io/atkrad/wait4x:${WAIT4X_VERSION} AS wait4x
FROM ${UPTRACK_SOURCE} AS builder

LABEL org.opencontainers.image.authors="Aurimas Niekis <aurimas@niekis.lt>"

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

RUN \
    mkdir /docker-entrypoint.d \
    ;

COPY --from=wait4x --chown=root /usr/bin/wait4x /usr/local/bin/wait4x

COPY --chown=root docker-entrypoint.d/* /docker-entrypoint.d
COPY --chown=root docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

FROM builder AS runtime
