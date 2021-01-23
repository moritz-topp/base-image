FROM ubuntu:18.04 as builder

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV TZ Europe/Berlin

# Insert Steam prompt answers (https://github.com/steamcmd/docker/blob/master/dockerfiles/ubuntu-18/Dockerfile)
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections

# Download libs
RUN dpkg --add-architecture i386 \
    && apt-get update -y \
	&& apt-get install -y --no-install-recommends steamcmd curl tar ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

# Download steamcmd
WORKDIR /app
RUN curl https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    --output steamcmd.tar.gz --silent \
    && tar -xvzf steamcmd.tar.gz \
    && rm steamcmd.tar.gz



FROM alpine:3.13 as prod

RUN apk update \
    && apk add --no-cache bash \
    && rm -rf /var/cache/apk/*

COPY --from=builder /app/steamcmd.sh /app/steamcmd.sh
COPY --from=builder /app/linux32/steamcmd /app/linux32/steamcmd
COPY --from=builder /app/linux32/libstdc++.so.6 /lib/
COPY --from=builder /lib/i386-linux-gnu /lib/

# One dry run, to get updates
RUN /app/steamcmd.sh +quit

# Install GMOD and CSS
RUN /app/steamcmd.sh +login anonymous +force_install_dir /app/css +app_update 232330 -validate +quit
RUN /app/steamcmd.sh +login anonymous +force_install_dir /app/gmod +app_update 4020 -validate +quit

RUN echo '"mountcfg" {"cstrike" "/app/css/cstrike"}' > /app/gmod/garrysmod/cfg/mount.cfg

ENTRYPOINT ["/app/gmod/srcds_run"]
