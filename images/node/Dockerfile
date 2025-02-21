ARG UPTRACK_SOURCE=node:alpine
ARG WAIT4X_VERSION=latest
FROM docker.io/atkrad/wait4x:${WAIT4X_VERSION} AS wait4x
FROM ${UPTRACK_SOURCE} AS builder

LABEL org.opencontainers.image.authors="Aurimas Niekis <aurimas@niekis.lt>"

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

RUN \
    apk add --no-cache libc6-compat \
    && mkdir /docker-entrypoint.d \
    ;

# Create a symlink for libssl.so.3 because poor Prisma doesn't know how to use libssl.so.3
RUN sh -c '[ ! -e /lib/libssl.so.3 ] && ln -s /usr/lib/libssl.so.3 /lib/libssl.so.3 || echo "Link already exists"'

COPY --from=wait4x --chown=root /usr/bin/wait4x /usr/local/bin/wait4x

COPY --chown=root docker-entrypoint.d/* /docker-entrypoint.d
COPY --chown=root docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

FROM builder AS runtime
