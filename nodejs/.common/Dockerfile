# dockerfiles/nodejs
#
# Dockerfile for Node.js.
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG

ARG LABEL_PREFIX
ARG NODEJS_VERSION
ARG NPM_VERSION
ARG ALPINE_NODEJS_PACKAGE_NAME
ARG ALPINE_NODEJS_PACKAGE_VERSION
ARG ALPINE_NPM_PACKAGE_NAME
ARG ALPINE_NPM_PACKAGE_VERSION

RUN test -n "$LABEL_PREFIX" && \
    test -n "$NODEJS_VERSION" && \
    test -n "$NPM_VERSION" && \
    test -n "$ALPINE_NODEJS_PACKAGE_NAME" && \
    test -n "$ALPINE_NODEJS_PACKAGE_VERSION" && \
    test -n "$ALPINE_NPM_PACKAGE_NAME" && \
    test -n "$ALPINE_NPM_PACKAGE_VERSION"

LABEL $LABEL_PREFIX.node.version=$NODEJS_VERSION \
      $LABEL_PREFIX.npm.version=$NODEJS_VERSION \
      $LABEL_PREFIX.alpine.node.package.name=$ALPINE_NODEJS_PACKAGE_NAME \
      $LABEL_PREFIX.alpine.node.package.version=$ALPINE_NODEJS_PACKAGE_VERSION \
      $LABEL_PREFIX.alpine.npm.package.name=$ALPINE_NPM_PACKAGE_NAME \
      $LABEL_PREFIX.alpine.npm.package.version=$ALPINE_NPM_PACKAGE_VERSION

ENV NODEJS_VERSION=$NODEJS_VERSION \
    NPM_VERSION=$NPM_VERSION \
    ALPINE_NODEJS_PACKAGE_NAME=$ALPINE_NODEJS_PACKAGE_NAME \
    ALPINE_NODEJS_PACKAGE_VERSION=$ALPINE_NODEJS_PACKAGE_VERSION \
    ALPINE_NPM_PACKAGE_NAME=$ALPINE_NPM_PACKAGE_NAME \
    ALPINE_NPM_PACKAGE_VERSION=$ALPINE_NPM_PACKAGE_VERSION

USER root

RUN apk add --no-cache \
    $ALPINE_NODEJS_PACKAGE_NAME="$ALPINE_NODEJS_PACKAGE_VERSION" \
    $ALPINE_NPM_PACKAGE_NAME="$ALPINE_NPM_PACKAGE_VERSION"

USER $USR
