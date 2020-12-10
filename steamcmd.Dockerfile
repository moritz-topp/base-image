FROM alpine:3.12 as builder

RUN addgroup -g 1000 steam \
    && adduser -u 1000 -G steam -s /bin/sh -D steam

RUN apk update \
    && apk add --no-cache curl tar \
    && rm -rf /var/cache/apk/*

WORKDIR /app

RUN curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
    --output steamcmd.tar.gz --silent
RUN tar -xvzf steamcmd.tar.gz \
    && rm steamcmd.tar.gz

FROM alpine:3.12 as prod

RUN apk update \
    && apk add --no-cache bash \
    && rm -rf /var/cache/apk/*

COPY --from=builder /app /app

# One dry run, to get updates
RUN /app/steamcmd +quit

ENTRYPOINT ["/app/steamcmd"]
CMD ["+help", "+quit"]
