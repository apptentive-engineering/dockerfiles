# dockerfiles/bumpversion
#
# Dockerfile for https://github.com/peritus/bumpversion
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG

ARG LABEL_PREFIX
ARG BUMPVERSION_VERSION

RUN test -n "$LABEL_PREFIX" && \
    test -n "$BUMPVERSION_VERSION"

LABEL $LABEL_PREFIX.bumpversion.version=$BUMPVERSION_VERSION

ENV BUMPVERSION_VERSION=$BUMPVERSION_VERSION

RUN pip install --user bumpversion==$BUMPVERSION_VERSION
