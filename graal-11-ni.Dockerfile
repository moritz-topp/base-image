FROM ghcr.io/graalvm/graalvm-ce
ENV TZ=Europe/Berlin
RUN gu install native-image
