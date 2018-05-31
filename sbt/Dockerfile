# dockerfiles/sbt
#
# Dockerfile for a Java 8 Scala development environment.
FROM ahawker/jre-8:latest

LABEL maintainer="Andrew Hawker <andrew.r.hawker@gmail.com>"

ARG SCALA_VERSION
ARG SBT_VERSION
ARG SCALA_DIR=/opt/scala
ARG SBT_DIR=/opt/sbt

RUN test -n "$SCALA_VERSION" && \
    test -n "$SBT_VERSION" && \
    test -n "$SCALA_DIR" && \
    test -n "$SBT_DIR"

ENV SCALA_VERSION=$SCALA_VERSION \
    SBT_VERSION=$SBT_VERSION

USER root

RUN apk add --no-cache bash && \
    mkdir -p $SBT_DIR && \
    wget -qO- https://sbt-downloads.cdnedge.bluemix.net/releases/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | tar xz -C $SBT_DIR --strip-components=1 && \
    chown -R $USER:$USER $SBT_DIR && \
    mkdir -p $SCALA_DIR && \
    wget -qO- https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz | tar xz -C $SCALA_DIR --strip-components=1 && \
    chown -R $USER:$USER $SCALA_DIR

ENV PATH=$PATH:$SCALA_DIR/bin:$SBT_DIR/bin

USER $USER

WORKDIR /home/$USER

RUN sbt sbtVersion
