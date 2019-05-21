FROM node:10.15-stretch-slim
LABEL maintainer="Porawit Poboonma"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt install -y git procps && \
    npm install -g yarn@^1.16 && \
    apt autoremove -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/node/workspaces

RUN npx -p @angular/cli@^7.3 ng new angular --style scss --routing --directory . --skip-install && \
    yarn && \
    yarn cache clean && \
    chown -R node:node .

USER node
ENV PATH="/home/node/workspaces/node_modules/.bin:${PATH}"
EXPOSE 4200
ENTRYPOINT ng serve --host 0.0.0.0 --disable-host-check

