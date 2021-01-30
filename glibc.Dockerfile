FROM alpine:3.13 AS prod

ARG GLIBC_VERSION=2.32-r0
ARG GLIBC_URL=https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION
ARG BASE_FILE=glibc-$GLIBC_VERSION.apk
ARG BIN_FILE=glibc-bin-$GLIBC_VERSION.apk
ARG I18N_FILE=glibc-i18n-$GLIBC_VERSION.apk

# Install glibc
RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates \
    # Install Public Key for sgerrand glibc Package
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    # Download glibc Packages
    && wget -q \
        "$GLIBC_URL/$BASE_FILE" \
        "$GLIBC_URL/$BIN_FILE" \
        "$GLIBC_URL/$I18N_FILE" \
    # Install Packages
    && apk add --no-cache \
        "$BASE_FILE" \
        "$BIN_FILE" \
        "$I18N_FILE" \
        libstdc++ \
    # Cleanup
    && rm "/etc/apk/keys/sgerrand.rsa.pub" \
    && rm "/root/.wget-hsts" \
    && apk del .build-dependencies \
    && rm \
        "$BASE_FILE" \
        "$BIN_FILE" \
        "$I18N_FILE"

# Set Locale
RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
