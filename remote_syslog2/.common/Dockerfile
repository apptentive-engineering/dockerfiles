# dockerfiles/remote_syslog2
#
# Dockerfile for https://github.com/papertrail/remote_syslog2

# Stage: Build
# Image responsible for pulling down the precompiled remote_syslog2 binary.
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG as build

ARG REMOTE_SYSLOG2_VERSION

RUN test -n "$REMOTE_SYSLOG2_VERSION"

USER root

RUN apk add --no-cache wget && \
    wget -q -O - https://github.com/papertrail/remote_syslog2/releases/download/v${REMOTE_SYSLOG2_VERSION}/remote_syslog_linux_amd64.tar.gz | tar -xzf - && \
    mv remote_syslog/remote_syslog  /usr/local/bin/remote_syslog

##################################################################################################

# Stage: Runtime
# Image responsible for running a remote_syslog2 binary.
FROM $REPO/$BASE_IMAGE:$TAG

ARG LABEL_PREFIX
ARG REMOTE_SYSLOG2_VERSION

RUN test -n "$LABEL_PREFIX" && \
    test -n "$REMOTE_SYSLOG2_VERSION"

LABEL $LABEL_PREFIX.remote_syslog2.version=$REMOTE_SYSLOG2_VERSION

ENV REMOTE_SYSLOG2_VERSION=$REMOTE_SYSLOG2_VERSION

COPY --from=build /usr/local/bin/remote_syslog /usr/local/bin/remote_syslog
