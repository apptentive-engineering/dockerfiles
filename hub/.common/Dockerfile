# dockerfiles/hub
#
# Dockerfile for https://github.com/github/hub

# Stage: Build
# Image responsible for building the 'hub' binary.
ARG BUILD_REPO
ARG BUILD_BASE_IMAGE
ARG BUILD_TAG=latest

ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $BUILD_REPO/$BUILD_BASE_IMAGE:$BUILD_TAG as build

ARG HUB_VERSION

RUN test -n "$HUB_VERSION"

USER root

RUN apk add --no-cache build-base bash make libffi-dev ruby ruby-dev ruby-ffi ruby-bundler groff util-linux

RUN go get github.com/github/hub && \
    cd "$GOPATH/src/github.com/github/hub" && \
    git checkout "tags/v$HUB_VERSION" && \
    make install prefix=/usr/local

##################################################################################################

# Stage: Runtime
# Copies 'hub' binary from the build image and configures image to run it.
FROM $REPO/$BASE_IMAGE:$TAG as runtime

ARG LABEL_PREFIX
ARG HUB_VERSION
ARG ALPINE_GIT_PACKAGE_NAME
ARG ALPINE_GIT_PACKAGE_VERSION

RUN test -n "$LABEL_PREFIX" && \
    test -n "$HUB_VERSION" && \
    test -n "$ALPINE_GIT_PACKAGE_NAME" && \
    test -n "$ALPINE_GIT_PACKAGE_VERSION"

LABEL $LABEL_PREFIX.hub.version=$HUB_VERSION

ENV HUB_VERSION=$HUB_VERSION

USER root

RUN apk add --no-cache $ALPINE_GIT_PACKAGE_NAME="$ALPINE_GIT_PACKAGE_VERSION"

USER $USR

COPY --from=build /usr/local/bin/hub /usr/local/bin/hub
