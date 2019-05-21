FROM node:10.15-stretch-slim
LABEL maintainer="Porawit Poboonma"

ARG YARN_VERSION=^1.16.0
ARG NG_VERSION=^7.3.0
ARG WORKSPACEDIR=/workspace

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

COPY etc/.vscode ${WORKSPACEDIR}/.vscode
COPY etc/.prettierrc ${WORKSPACEDIR}

ENV PATH="${WORKSPACEDIR}/node_modules/.bin:${PATH}"
ENV DEBIAN_FRONTEND=dialog
EXPOSE 4200

