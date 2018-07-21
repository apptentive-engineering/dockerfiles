# dockerfiles/cookiecutter
#
# Dockerfile for Cookiecutter (https://github.com/audreyr/cookiecutter).
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG

ARG LABEL_PREFIX
ARG COOKIECUTTER_VERSION

RUN test -n "$LABEL_PREFIX" && \
    test -n "$COOKIECUTTER_VERSION"

LABEL $LABEL_PREFIX.cookiecutter.version=$COOKIECUTTER_VERSION

ENV COOKIECUTTER_VERSION=$COOKIECUTTER_VERSION

RUN pip install --user cookiecutter==$COOKIECUTTER_VERSION
