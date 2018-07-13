# dockerfiles/alpine
#
# Base Dockerfile for Alpine Linux based images.
ARG BASE_IMAGE
ARG BASE_IMAGE_TAG=latest

FROM $BASE_IMAGE:$BASE_IMAGE_TAG

ARG USR
ARG GRP
ARG UID
ARG GID
ARG COMMIT
ARG BUILD_ID
ARG BUILD_TS
ARG INIT_VERSION
ARG MAINTAINER
ARG LABEL_PREFIX

RUN test -n "$USR" && \
    test -n "$GRP" && \
    test -n "$UID" && \
    test -n "$GID" && \
    test -n "$COMMIT" && \
    test -n "$BUILD_ID" && \
    test -n "$BUILD_TS" && \
    test -n "$INIT_VERSION" && \
    test -n "$MAINTAINER" && \
    test -n "$LABEL_PREFIX"

LABEL $LABEL_PREFIX.commit=$COMMIT \
      $LABEL_PREFIX.build.id=$BUILD_ID \
      $LABEL_PREFIX.build.ts=$BUILD_TS \
      $LABEL_PREFIX.init.version=$INIT_VERSION \
      $LABEL_PREFIX.maintainer=$MAINTAINER

ENV USER=$USR \
    GROUP=$GRP \
    UID=$UID \
    GID=$GID \
    COMMIT=$COMMIT \
    BUILD_ID=$BUILD_ID \
    BUILD_TS=$BUILD_TS \
    INIT_VERSION=$INIT_VERSION \
    MAINTAINER=$MAINTAINER \
    LABEL_PREFIX=$LABEL_PREFIX \
    LANG=C.UTF-8

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${INIT_VERSION}/dumb-init_${INIT_VERSION}_amd64 && \
    chmod +x /usr/local/bin/dumb-init

RUN addgroup -S $GRP -g $GID && \
    adduser -S -G $GRP -u $UID $USR

USER $USR
WORKDIR /home/$USR

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["/usr/bin/env", "sh"]
