# dockerfiles/python/3
#
# Dockerfile for Python 3.
FROM ahawker/alpine:latest

LABEL maintainer="Andrew Hawker <andrew.r.hawker@gmail.com>"

ARG PYTHON_VERSION
ARG ALPINE_PACKAGE_NAME
ARG ALPINE_PACKAGE_VERSION

RUN test -n "$PYTHON_VERSION" && \
    test -n "$ALPINE_PACKAGE_NAME" && \
    test -n "$ALPINE_PACKAGE_VERSION"

ENV PYTHON_VERSION=$PYTHON_VERSION \
    ALPINE_PACKAGE_NAME=$ALPINE_PACKAGE_NAME \
    ALPINE_PACKAGE_VERSION=$ALPINE_PACKAGE_VERSION

USER root

RUN apk add --no-cache $ALPINE_PACKAGE_NAME="$ALPINE_PACKAGE_VERSION" && \
    pip3 install --no-cache-dir --upgrade pip

ENV PATH=$PATH:/home/$USER/.local/bin

USER $USER
