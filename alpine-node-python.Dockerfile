FROM node:15.3.0-alpine3.12

RUN apk add --no-cache --virtual .gyp python make g++
