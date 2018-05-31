# dockerfiles/cookiecutter
#
# Dockerfile for Cookiecutter (https://github.com/audreyr/cookiecutter).
FROM ahawker/python3:latest

LABEL maintainer="Andrew Hawker <andrew.r.hawker@gmail.com>"

ARG COOKIECUTTER_VERSION

RUN test -n "$COOKIECUTTER_VERSION"

ENV COOKIECUTTER_VERSION=$COOKIECUTTER_VERSION

RUN pip install --user cookiecutter==$COOKIECUTTER_VERSION
