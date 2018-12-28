# dockerfiles/ruby
#
# Dockerfile for Ruby

# Stage: Build
# Image responsible for building the ruby binaries.
ARG BUILD_REPO
ARG BUILD_BASE_IMAGE
ARG BUILD_TAG=latest

ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $BUILD_REPO/$BUILD_BASE_IMAGE:$BUILD_TAG as build

##################################################################################################

# Stage: Runtime
# Copies ruby binaries from the build image and configures image to run it.
FROM $REPO/$BASE_IMAGE:$TAG as runtime

ARG LABEL_PREFIX
ARG RUBY_VERSION
ARG RUBY_GEM_VERSION
ARG GEMS_VERSION
ARG BUNDLER_VERSION

RUN test -n "$LABEL_PREFIX" && \
    test -n "$RUBY_VERSION" && \
    test -n "$RUBY_GEM_VERSION" && \
    test -n "$GEMS_VERSION" && \
    test -n "$BUNDLER_VERSION"

LABEL $LABEL_PREFIX.ruby.version=$RUBY_VERSION \
      $LABEL_PREFIX.ruby.gem.version=$RUBY_GEM_VERSION \
      $LABEL_PREFIX.gems.version=$GEMS_VERSION \
      $LABEL_PREFIX.bundler.version=$BUNDLER_VERSION

ENV RUBY_VERSION=$RUBY_VERSION \
    RUBY_GEM_VERSION=$RUBY_GEM_VERSION \
    GEMS_VERSION=$GEMS_VERSION \
    BUNDLER_VERSION=$BUNDLER_VERSION

RUN echo "gem: --no-ri --no-rdoc --no-document --no-suggestions --user-install" > /home/$USR/.gemrc

USER root

COPY --from=build /usr/local /usr/local

RUN apk add --no-cache \
        readline && \
    rundeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" && \
    apk add --no-cache \
        $rundeps \
        bzip2 \
        libffi-dev \
        procps \
        yaml-dev \
        zlib-dev && \
    gem update --system $GEMS_VERSION

ENV GEM_HOME=/usr/local/bundle

ENV BUNDLE_PATH=$GEM_HOME \
    BUNDLE_APP_CONFIG=$GEM_HOME \
    BUNDLE_SILENCE_ROOT_WARNING=1

ENV PATH=$PATH:/home/$USR/.gem/ruby/$RUBY_GEM_VERSION/bin:$GEM_HOME/bin:$BUNDLE_PATH/gems/bin

USER $USR

RUN gem install bundler --force --version $BUNDLER_VERSION
