# dockerfiles/golang
#
# Dockerfile for golang

# Stage: Build
# Image responsible for building the golang binaries.
ARG BUILD_REPO
ARG BUILD_BASE_IMAGE
ARG BUILD_TAG=latest

ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $BUILD_REPO/$BUILD_BASE_IMAGE:$BUILD_TAG as build

##################################################################################################

# Stage: Runtime
# Copies golang binaries from the build image and configures image to run it.
FROM $REPO/$BASE_IMAGE:$TAG as runtime

ARG LABEL_PREFIX
ARG GOLANG_VERSION
ARG GOPATH
ARG GOROOT
ARG ALPINE_GIT_PACKAGE_NAME
ARG ALPINE_GIT_PACKAGE_VERSION

RUN test -n "$LABEL_PREFIX" && \
    test -n "$GOLANG_VERSION" && \
    test -n "$GOPATH" && \
    test -n "$GOROOT" && \
    test -n "$ALPINE_GIT_PACKAGE_NAME" && \
    test -n "$ALPINE_GIT_PACKAGE_VERSION"

LABEL $LABEL_PREFIX.golang.version=$GOLANG_VERSION

ENV GOLANG_VERSION=$GOLANG_VERSION \
    GOPATH=$GOPATH \
    GOROOT=$GOROOT \
    ALPINE_GIT_PACKAGE_NAME=$ALPINE_GIT_PACKAGE_NAME \
    ALPINE_GIT_PACKAGE_VERSION=$ALPINE_GIT_PACKAGE_VERSION

ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

COPY --from=build /usr/local/go /usr/local/go

USER root

RUN apk add --no-cache $ALPINE_GIT_PACKAGE_NAME="$ALPINE_GIT_PACKAGE_VERSION"

RUN [ ! -e /etc/nsswitch.conf ] && echo "hosts: files dns" > /etc/nsswitch.conf

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && \
    chmod -R 755 "$GOPATH" && \
    chown -R "$USR:$GRP" "$GOPATH"

USER $USR

WORKDIR $GOPATH
