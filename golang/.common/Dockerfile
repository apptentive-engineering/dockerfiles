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

RUN test -n "$LABEL_PREFIX" && \
    test -n "$GOLANG_VERSION" && \
    test -n "$GOPATH"

LABEL $LABEL_PREFIX.golang.version=$GOLANG_VERSION

ENV GOLANG_VERSION=$GOLANG_VERSION \
    GOPATH=$GOPATH

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

COPY --from=build /usr/local/go/bin /usr/local/bin

USER root

RUN [ ! -e /etc/nsswitch.conf ] && echo "hosts: files dns" > /etc/nsswitch.conf

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && \
    chmod -R 755 "$GOPATH" && \
    chown -R "$USER:$GROUP" "$GOPATH"

USER $USER

WORKDIR $GOPATH
