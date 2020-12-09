FROM node:15.3.0-alpine3.12

RUN apk add --no-cache --virtual python3 make g++
