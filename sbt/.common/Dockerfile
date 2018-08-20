# dockerfiles/sbt
#
# Dockerfile for SBT (https://www.scala-sbt.org/)
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG

ARG LABEL_PREFIX
ARG SBT_VERSION
ARG SBT_DIR

RUN test -n "$LABEL_PREFIX" && \
    test -n "$SBT_VERSION" && \
    test -n "$SBT_DIR"

LABEL $LABEL_PREFIX.sbt.version=$SBT_VERSION

ENV SBT_VERSION=$SBT_VERSION

USER root

RUN mkdir -p $SBT_DIR && \
    wget -qO- https://sbt-downloads.cdnedge.bluemix.net/releases/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | tar xz -C $SBT_DIR --strip-components=1 && \
    chown -R $USR:$USR $SBT_DIR

ENV PATH=$PATH:$SBT_DIR/bin

USER $USR

RUN sbt sbtVersion
