FROM oracle/graalvm-ce:20.3.0-java11

RUN gu install native-image
