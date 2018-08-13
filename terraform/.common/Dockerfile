# dockerfiles/terraform
#
# Dockerfile for https://www.terraform.io

# Stage: Build
# Image responsible for pulling down and validating a precompiled Terraform binary.
ARG BUILD_REPO
ARG BUILD_BASE_IMAGE
ARG BUILD_TAG=latest

ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $BUILD_REPO/$BUILD_BASE_IMAGE:$BUILD_TAG as build

ARG TERRAFORM_VERSION
ARG TERRAFORM_SHA256

RUN test -n "$TERRAFORM_VERSION" && \
    test -n "$TERRAFORM_SHA256"

RUN apk add --update curl openssh && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

##################################################################################################

# Stage: Runtime
# Image responsible for running a Terraform binary.
FROM $REPO/$BASE_IMAGE:$TAG as runtime

ARG LABEL_PREFIX
ARG TERRAFORM_VERSION
ARG TERRAFORM_SHA256

RUN test -n "$LABEL_PREFIX" && \
    test -n "$TERRAFORM_VERSION" && \
    test -n "$TERRAFORM_SHA256"

LABEL $LABEL_PREFIX.terraform.version=$TERRAFORM_VERSION

ENV TERRAFORM_VERSION=$TERRAFORM_VERSION \
    TERRAFORM_SHA256=$TERRAFORM_SHA256

USER root

RUN apk add --update ca-certificates

USER $USR

COPY --from=build /bin/terraform /usr/local/bin/terraform
