FROM node:10.15-stretch-slim
LABEL maintainer="Porawit Poboonma"

ARG YARN_VERSION=^1.16.0
ARG NG_VERSION=^7.3.0
ARG WORKSPACEDIR=/workspace
ARG INSIDER_COMMIT=4ca38ce5584d7cd67b435b3c32ef1240c6a29628

ENV DEBIAN_FRONTEND=noninteractive

COPY etc/.gitconfig /root
WORKDIR ${WORKSPACEDIR}

RUN apt-get update -y && \
    apt-get install -y git procps && \
    npm install -g yarn@${YARN_VERSION} && \
    npx -p @angular/cli@${NG_VERSION} ng new angular --style scss --routing --directory . --skip-install && \
    yarn && \
    yarn cache clean && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.vscode-remote/bin/code-insiders && \
    cd /root/.vscode-remote/bin/code-insiders && \
    wget -nv -O vscode-server-linux-x64.tar.gz https://update.code.visualstudio.com/commit:${INSIDER_COMMIT}/server-linux-x64/insider && \
    tar -xzf vscode-server-linux-x64.tar.gz --strip-components 1 && \
    /root/.vscode-remote/bin/code-insiders/server.sh --force \
        --install-extension angular.ng-template \
        --install-extension ms-vscode.vscode-typescript-tslint-plugin \
        --install-extension esbenp.prettier-vscode && \
    cd /root && \
    rm -rf /root/.vscode-remote/bin/code-insiders

COPY etc/.vscode ${WORKSPACEDIR}/.vscode
COPY etc/.prettierrc ${WORKSPACEDIR}

ENV PATH="${WORKSPACEDIR}/node_modules/.bin:${PATH}"
ENV DEBIAN_FRONTEND=dialog
EXPOSE 4200

