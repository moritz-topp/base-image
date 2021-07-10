FROM moritztopp/base-image:node-npm
ENV TZ=Europe/Berlin
RUN apk add --no-cache --virtual .gyp g++ make python3
