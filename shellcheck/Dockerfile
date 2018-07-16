# dockerfiles/shellcheck
#
# Dockerfile for https://github.com/koalaman/shellcheck

# Stage: Build
# Image responsible for building the 'shellcheck' binary.
ARG BUILD_REPO
ARG BUILD_BASE_IMAGE
ARG BUILD_TAG=latest

ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $BUILD_REPO/$BUILD_BASE_IMAGE:$BUILD_TAG as build

##################################################################################################

# Stage: Runtime
# Copies 'shellcheck' binary from the build image and configures image to run it.
FROM $REPO/$BASE_IMAGE:$TAG as runtime

ARG LABEL_PREFIX
ARG SHELLCHECK_VERSION

RUN test -n "$LABEL_PREFIX" && \
    test -n "$SHELLCHECK_VERSION"

LABEL $LABEL_PREFIX.shellcheck.version=$SHELLCHECK_VERSION

ENV SHELLCHECK_VERSION=$SHELLCHECK_VERSION

USER root

RUN apk add --no-cache file

USER $USER

COPY --from=build /bin/shellcheck /usr/local/bin/shellcheck
