# dockerfiles/cookiecutter
#
# Dockerfile for Cookiecutter (https://github.com/audreyr/cookiecutter).
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG

ARG COOKIECUTTER_VERSION

RUN test -n "$COOKIECUTTER_VERSION"

ENV COOKIECUTTER_VERSION=$COOKIECUTTER_VERSION

RUN pip install --user cookiecutter==$COOKIECUTTER_VERSION
