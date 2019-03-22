# dockerfiles/sbt
#
# Dockerfile for SBT (https://www.scala-sbt.org/)
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG

ARG LABEL_PREFIX
ARG SCALA_VERSION
ARG SCALA_DIR
ARG SBT_VERSION
ARG SBT_DIR

RUN test -n "$LABEL_PREFIX" && \
    test -n "$SCALA_VERSION" && \
    test -n "$SCALA_DIR" && \
    test -n "$SBT_VERSION" && \
    test -n "$SBT_DIR"

LABEL $LABEL_PREFIX.sbt.version=$SBT_VERSION \
      $LABEL_PREFIX.scala.version=$SCALA_VERSION

ENV SBT_VERSION=$SBT_VERSION \
    SCALA_VERSION=$SCALA_VERSION

USER root

RUN apk add --no-cache bash && \
    mkdir -p $SCALA_DIR && \
    mkdir -p $SBT_DIR && \
    wget -qO- https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz | tar xz -C $SCALA_DIR --strip-components=1 && \
    wget -qO- https://sbt-downloads.cdnedge.bluemix.net/releases/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | tar xz -C $SBT_DIR --strip-components=1 && \
    chown -R $USR:$GRP $SCALA_DIR && \
    chown -R $USR:$GRP $SBT_DIR

ENV PATH=$PATH:$SBT_DIR/bin:$SCALA_DIR/bin

USER $USR

RUN sbt sbtVersion
