FROM alpine

ENV LANG=C.UTF-8

# Get Basic Packages
RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates

ARG GLIBC_VERSION=2.32-r0
ARG GLIBC_URL=https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION
ARG BASE_FILE=glibc-$GLIBC_VERSION.apk
ARG BIN_FILE=glibc-bin-$GLIBC_VERSION.apk
ARG I18N_FILE=glibc-i18n-$GLIBC_VERSION.apk

# Download Packages
RUN wget -q \
    "$GLIBC_URL/$BASE_FILE" \
    "$GLIBC_URL/$BIN_FILE" \
    "$GLIBC_URL/$I18N_FILE"

# Install Packages
RUN apk add --no-cache \
        "$BASE_FILE" \
        "$BIN_FILE" \
        "$I18N_FILE"

# Set Locale
RUN /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh

# Cleanup
RUN apk del glibc-i18n \
    && rm "/root/.wget-hsts" \
    && apk del .build-dependencies \
    && rm \
        "$BASE_FILE" \
        "$BIN_FILE" \
        "$I18N_FILE"

# Add last Package
RUN apk add --no-cache libstdc++
