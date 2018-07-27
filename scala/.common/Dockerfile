# dockerfiles/scala
#
# Dockerfile for Scala programming language.
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG

ARG LABEL_PREFIX
ARG SCALA_VERSION
ARG SCALA_DIR

RUN test -n "$LABEL_PREFIX" && \
    test -n "$SCALA_VERSION" && \
    test -n "$SCALA_DIR"

LABEL $LABEL_PREFIX.scala.version=$SCALA_VERSION

ENV SCALA_VERSION=$SCALA_VERSION

USER root

RUN apk add --no-cache bash && \
    mkdir -p $SCALA_DIR && \
    wget -qO- https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz | tar xz -C $SCALA_DIR --strip-components=1 && \
    chown -R $USER:$USER $SCALA_DIR

ENV PATH=$PATH:$SCALA_DIR/bin

USER $USER
