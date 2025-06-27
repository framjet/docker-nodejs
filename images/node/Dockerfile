ARG UPTRACK_SOURCE=node:alpine
ARG WAIT4X_VERSION=latest
FROM framjet/alpine AS alpine
FROM ${UPTRACK_SOURCE} AS builder

LABEL org.opencontainers.image.authors="Aurimas Niekis <aurimas@niekis.lt>"

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable pnpm

RUN \
    apk add --no-cache libc6-compat \
    && mkdir /docker-entrypoint.d \
    ;

# Create a symlink for libssl.so.3 because poor Prisma doesn't know how to use libssl.so.3
RUN sh -c '[ ! -e /lib/libssl.so.3 ] && ln -s /usr/lib/libssl.so.3 /lib/libssl.so.3 || echo "Link already exists"'

# Copy wait4x binary from alpine image
COPY --from=alpine --chown=root /usr/local/bin/wait4x /usr/local/bin/wait4x

# Copy entrypoints from alpine base image
COPY --chown=root --from=alpine /docker-entrypoint.d/* /docker-entrypoint.d/
COPY --chown=root --from=alpine /docker-entrypoint.functions /docker-entrypoint.functions

# Copy custom entrypoint script
COPY --chown=root docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

FROM builder AS shell

RUN apk add --no-cache zsh zsh-vcs git curl vim nano shadow htop btop \
    && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && git clone --depth=1 https://github.com/ntnyq/omz-plugin-pnpm.git ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/pnpm \
    && sed -i 's/robbyrussell/agnoster/' /root/.zshrc \
    && sed -i 's/plugins=(git)/plugins=(git npm node yarn pnpm)/' /root/.zshrc \
    && echo 'export PATH="$PATH:/var/www/html/vendor/bin"' >> /root/.zshrc \
    && chsh -s /bin/zsh

# Copy script to run zsh as bash terminal used in docker terminals
COPY --chown=root ./bash.sh /bin/bash
COPY --chown=root ./shell-docker-entrypoint.sh /docker-entrypoint.sh

SHELL ["/bin/zsh"]



FROM builder AS runtime

CMD ["node"]
