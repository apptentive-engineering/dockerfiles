# dockerfiles/kubectl
#
# Dockerfile for https://github.com/kubernetes/kubectl
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG

ARG LABEL_PREFIX
ARG KUBECTL_VERSION
ARG KUBECTL_PATH

RUN test -n "$LABEL_PREFIX" && \
    test -n "$KUBECTL_VERSION" && \
    test -n "$KUBECTL_PATH"

LABEL $LABEL_PREFIX.kubectl.version=$KUBECTL_VERSION

ENV KUBECTL_VERSION=$KUBECTL_VERSION

ADD "https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl" "$KUBECTL_PATH"

USER root

RUN chown -R $USER:$USER $KUBECTL_PATH && \
    chmod u+x $KUBECTL_PATH

USER $USER
