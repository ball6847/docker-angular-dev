FROM node:10.15-stretch-slim
LABEL maintainer="Porawit Poboonma"

ARG YARN_VERSION=^1.16.0
ARG NG_VERSION=^7.3.0
ARG HOMEDIR=/root
ARG INSIDER_COMMIT=4ca38ce5584d7cd67b435b3c32ef1240c6a29628
ENV SRCDIR=/root/src
ENV WORKSPACEDIR=/root/workspace

ENV DEBIAN_FRONTEND=noninteractive

COPY start.sh /start.sh
COPY etc/.gitconfig ${HOMEDIR}

# system preparation
RUN apt-get update -y && \
    apt-get install -y git procps && \
    npm install -g yarn@${YARN_VERSION} && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

USER node

RUN mkdir -p ${WORKSPACEDIR} && \
    mkdir -p ${SRCDIR} && \
    mkdir -p ${HOMEDIR}/node_modules && \
    ln -s ${HOMEDIR}/node_modules ${SRCDIR}/node_modules && \
    cd ${SRCDIR} && \
    npx -p @angular/cli@${NG_VERSION} ng new angular --style scss --routing --directory . --skip-install && \
    yarn && \
    yarn cache clean

RUN mkdir -p ${HOMEDIR}/.vscode-remote/bin/code-insiders && \
    cd ${HOMEDIR}/.vscode-remote/bin/code-insiders && \
    wget -nv -O vscode-server-linux-x64.tar.gz https://update.code.visualstudio.com/commit:${INSIDER_COMMIT}/server-linux-x64/insider && \
    tar -xzf vscode-server-linux-x64.tar.gz --strip-components 1 && \
    ${HOMEDIR}/.vscode-remote/bin/code-insiders/server.sh --force \
        --install-extension angular.ng-template \
        --install-extension ms-vscode.vscode-typescript-tslint-plugin \
        --install-extension esbenp.prettier-vscode && \
    cd ${HOMEDIR} && \
    rm -rf ${HOMEDIR}/.vscode-remote/bin/code-insiders

COPY etc/.vscode ${SRCDIR}/.vscode
COPY etc/.prettierrc ${SRCDIR}

WORKDIR ${WORKSPACEDIR}
ENV PATH="${HOMEDIR}/node_modules/.bin:${PATH}"
ENV DEBIAN_FRONTEND=dialog
EXPOSE 4200

