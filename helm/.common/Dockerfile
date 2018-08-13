# dockerfiles/helm
#
# Dockerfile for https://github.com/helm/helm
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG

ARG LABEL_PREFIX
ARG HELM_VERSION
ARG HELM_PATH

RUN test -n "$LABEL_PREFIX" && \
    test -n "$HELM_VERSION" && \
    test -n "$HELM_PATH"

LABEL $LABEL_PREFIX.helm.version=$HELM_VERSION

ENV HELM_VERSION=$HELM_VERSION

USER root

RUN wget -qO- http://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xzO linux-amd64/helm > $HELM_PATH

RUN chown -R $USR:$USR $HELM_PATH && \
    chmod u+x $HELM_PATH

USER $USR
