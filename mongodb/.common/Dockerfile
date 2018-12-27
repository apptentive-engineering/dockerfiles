# dockerfiles/mongodb
#
# Dockerfile for MongoDB (https://www.mongodb.com/)

# Stage: Deps
# Image responsible for pulling down image dependencies.
ARG BASE_IMAGE_REPO
ARG BASE_IMAGE
ARG BASE_IMAGE_TAG=latest

FROM $BASE_IMAGE_REPO/$BASE_IMAGE:$BASE_IMAGE_TAG as deps

ARG DUMB_INIT_VERSION

RUN test -n "$DUMB_INIT_VERSION"

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget && \
    wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 && \
    chmod +x /usr/local/bin/dumb-init

##################################################################################################

# Stage: Runtime
# Image responsible for setting up a MongoDB instance.
FROM $BASE_IMAGE_REPO/$BASE_IMAGE:$BASE_IMAGE_TAG as runtime

ARG USR
ARG GRP
ARG USR_ID
ARG GRP_ID
ARG REPO
ARG TAG
ARG COMMIT
ARG BUILD_ID
ARG BUILD_TS
ARG VERSION
ARG DUMB_INIT_VERSION
ARG MAINTAINER
ARG LABEL_PREFIX
ARG ENV_PREFIX
ARG WORKDIR
ARG MONGODB_VERSION
ARG MONGODB_USER
ARG MONGODB_GROUP

RUN test -n "$USR" && \
    test -n "$GRP" && \
    test -n "$USR_ID" && \
    test -n "$GRP_ID" && \
    test -n "$REPO" && \
    test -n "$TAG" && \
    test -n "$COMMIT" && \
    test -n "$BUILD_ID" && \
    test -n "$BUILD_TS" && \
    test -n "$VERSION" && \
    test -n "$DUMB_INIT_VERSION" && \
    test -n "$MAINTAINER" && \
    test -n "$LABEL_PREFIX" && \
    test -n "$ENV_PREFIX" && \
    test -n "$WORKDIR" && \
    test -n "$MONGODB_VERSION" && \
    test -n "$MONGODB_USER" && \
    test -n "$MONGODB_GROUP"

RUN ([ $USR_ID = `id -u $MONGODB_USER` ] || (echo "USR_ID must eq `id -u $MONGODB_USER`" && exit 1)) && \
    ([ $GRP_ID = `id -u $MONGODB_GROUP` ] || (echo "GRP_ID must eq `id -u $MONGODB_GROUP`" && exit 1))

LABEL $LABEL_PREFIX.commit=$COMMIT \
      $LABEL_PREFIX.build.id=$BUILD_ID \
      $LABEL_PREFIX.build.ts=$BUILD_TS \
      $LABEL_PREFIX.dumb-init.version=$DUMB_INIT_VERSION \
      $LABEL_PREFIX.maintainer=$MAINTAINER \
      $LABEL_PREFIX.mongodb.version=$MONGODB_VERSION

ENV USR=$USR \
    GRP=$GRP \
    USR_ID=$USR_ID \
    GRP_ID=$GRP_ID \
    ENV_PREFIX=$ENV_PREFIX \
    ${ENV_PREFIX}_REPO=$REPO \
    ${ENV_PREFIX}_TAG=$TAG \
    ${ENV_PREFIX}_COMMIT=$COMMIT \
    ${ENV_PREFIX}_BUILD_ID=$BUILD_ID \
    ${ENV_PREFIX}_BUILD_TS=$BUILD_TS \
    ${ENV_PREFIX}_VERSION=$VERSION \
    DUMB_INIT_VERSION=$DUMB_INIT_VERSION \
    MAINTAINER=$MAINTAINER \
    LABEL_PREFIX=$LABEL_PREFIX \
    WORKDIR=$WORKDIR \
    MONGODB_VERSION=$MONGODB_VERSION \
    MONGODB_USER=$MONGODB_USER \
    MONGODB_GROUP=$MONGODB_GROUP \
    LANG=C.UTF-8

USER root

RUN groupadd --non-unique --system --gid $GRP_ID $GRP && \
    useradd --non-unique --system --gid $GRP_ID --uid $USR_ID $USR && \
    mkdir -p /home/$USR && \
    chown -R $USR:$GRP /home/$USR && \
    mkdir -p /Users && \
    ln -s /home/$USR /Users/$USR

RUN mkdir -p /home/$MONGODB_USER && \
    chown -R $MONGODB_USER:$MONGODB_GROUP /home/$MONGODB_USER

COPY --from=deps /usr/local/bin/dumb-init /usr/local/bin/dumb-init

USER $USR

WORKDIR $WORKDIR

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["docker-entrypoint.sh", "mongod"]
