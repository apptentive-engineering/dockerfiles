# dockerfiles/awscli
#
# Dockerfile for https://aws.amazon.com/cli/
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG

ARG LABEL_PREFIX
ARG AWSCLI_VERSION

RUN test -n "$LABEL_PREFIX" && \
    test -n "$AWSCLI_VERSION"

LABEL $LABEL_PREFIX.awscli.version=$AWSCLI_VERSION

ENV AWSCLI_VERSION=$AWSCLI_VERSION

RUN pip install --user awscli==$AWSCLI_VERSION
