# dockerfiles/alpine
#
# Base Dockerfile for Alpine Linux based images.
ARG BASE_IMAGE
ARG TAG=latest

FROM $BASE_IMAGE:$TAG

ARG USR
ARG GRP
ARG UID
ARG GID
ARG COMMIT
ARG BUILD_ID
ARG INIT_VERSION
ARG MAINTAINER

RUN test -n "$USR" && \
    test -n "$GRP" && \
    test -n "$UID" && \
    test -n "$GID" && \
    test -n "$COMMIT" && \
    test -n "$BUILD_ID" && \
    test -n "$INIT_VERSION" && \
    test -n "$MAINTAINER"

LABEL maintainer=$MAINTAINER

ENV USER=$USR \
    GROUP=$GRP \
    UID=$UID \
    GID=$GID \
    COMMIT=$COMMIT \
    BUILD_ID=$BUILD_ID \
    INIT_VERSION=$INIT_VERSION \
    MAINTAINER=$MAINTAINER \
    LANG=C.UTF-8

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${INIT_VERSION}/dumb-init_${INIT_VERSION}_amd64 && \
    chmod +x /usr/local/bin/dumb-init

RUN addgroup -S $GRP -g $GID && \
    adduser -S -G $GRP -u $UID $USR

USER $USR
WORKDIR /home/$USR

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["/usr/bin/env", "sh"]
