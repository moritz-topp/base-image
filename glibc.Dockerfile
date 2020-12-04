FROM alpine

ENV LANG=C.UTF-8

# Get Basic Packages
RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates

ARG GLIBC_VERSION=2.32-r0
ARG GLIBC_URL=https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION
ARG BASE_FILE=glibc-$GLIBC_VERSION.apk
ARG BIN_FILE=glibc-bin-$GLIBC_VERSION.apk
ARG I18N_FILE=glibc-i18n-$GLIBC_VERSION.apk

# Add Packages and remove rest Data
RUN echo \
        "-----BEGIN PUBLIC KEY-----\
        MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApZ2u1KJKUu/fW4A25y9m\
        y70AGEa/J3Wi5ibNVGNn1gT1r0VfgeWd0pUybS4UmcHdiNzxJPgoWQhV2SSW1JYu\
        tOqKZF5QSN6X937PTUpNBjUvLtTQ1ve1fp39uf/lEXPpFpOPL88LKnDBgbh7wkCp\
        m2KzLVGChf83MS0ShL6G9EQIAUxLm99VpgRjwqTQ/KfzGtpke1wqws4au0Ab4qPY\
        KXvMLSPLUp7cfulWvhmZSegr5AdhNw5KNizPqCJT8ZrGvgHypXyiFvvAH5YRtSsc\
        Zvo9GI2e2MaZyo9/lvb+LbLEJZKEQckqRj4P26gmASrZEPStwc+yqy1ShHLA0j6m\
        1QIDAQAB\
        -----END PUBLIC KEY-----" | sed 's/   */\n/g' > "/etc/apk/keys/sgerrand.rsa.pub" \
    && wget -q \
        "$GLIBC_URL/$BASE_FILE" \
        "$GLIBC_URL/$BIN_FILE" \
        "$GLIBC_URL/$I18N_FILE" \
    && apk add --no-cache \
        "$BASE_FILE" \
        "$BIN_FILE" \
        "$I18N_FILE" \
        #libstdc++ \
    && rm "/etc/apk/keys/sgerrand.rsa.pub" \
    && apk del glibc-i18n \
    && rm "/root/.wget-hsts" \
    && apk del .build-dependencies \
    && rm \
        "$BASE_FILE" \
        "$BIN_FILE" \
        "$I18N_FILE"

# Set Locale
RUN /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh
