FROM nginx:latest AS build

RUN apt update && apt install -y git

RUN mkdir -m 700 /root/.ssh; \
  touch -m 600 /root/.ssh/known_hosts; \
  ssh-keyscan github.com > /root/.ssh/known_hosts

ARG CACHEBUST=1

RUN --mount=type=ssh,id=github git clone git@github.com:MaxNelipin/diplom-app.git /usr/share/nginx/html/1
