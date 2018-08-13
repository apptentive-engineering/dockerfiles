# dockerfiles/dockerfiles-env
#
# Dockerfile for https://github.com/ahawker/dockerfiles
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG

ARG ENV_PREFIX
ARG LABEL_PREFIX
ARG BRANCH
ARG COMMIT
ARG TAG
ARG BUILD_ID
ARG BUILD_TS

RUN test -n "$ENV_PREFIX" && \
    test -n "$LABEL_PREFIX" && \
    test -n "$BRANCH" && \
    test -n "$COMMIT" && \
    test -n "$TAG" && \
    test -n "$BUILD_ID" && \
    test -n "$BUILD_TS"

LABEL $LABEL_PREFIX.branch=$BRANCH \
      $LABEL_PREFIX.commit=$COMMIT \
      $LABEL_PREFIX.tag=$TAG \
      $LABEL_PREFIX.build.id=$BUILD_ID \
      $LABEL_PREFIX.build.ts=$BUILD_TS

ENV ENV_PREFIX=$ENV_PREFIX \
    ${ENV_PREFIX}_LABEL_PREFIX=$LABEL_PREFIX \
    ${ENV_PREFIX}_BRANCH=$BRANCH \
    ${ENV_PREFIX}_COMMIT=$COMMIT \
    ${ENV_PREFIX}_TAG=$TAG \
    ${ENV_PREFIX}_BUILD_ID=$BUILD_ID \
    ${ENV_PREFIX}_BUILD_TS=$BUILD_TS

CMD ["/usr/bin/env", "sh", "-c", "env | grep ${ENV_PREFIX}_ | sed -e 's/^/export /'"]
