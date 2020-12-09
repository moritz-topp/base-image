FROM moritztopp/alpine-node-npm

RUN apk add --no-cache --virtual .gyp g++ make python3
