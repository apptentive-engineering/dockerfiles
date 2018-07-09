# dockerfiles/terraform
#
# Dockerfile for https://www.terraform.io

# Stage: Build
# Image responsible for pulling down and validating a precompiled Terraform binary.
FROM alpine:latest as build

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
# TODO: Unsure how to parameterize a FROM statement with ARG in a multi-stage build.
FROM ahawker/alpine:latest as runtime

ARG LABEL_PREFIX
ARG TERRAFORM_VERSION
ARG TERRAFORM_SHA256

RUN test -n "$LABEL_PREFIX"

LABEL $LABEL_PREFIX.terraform.version=$TERRAFORM_VERSION

ENV TERRAFORM_VERSION=$TERRAFORM_VERSION \
    TERRAFORM_SHA256=$TERRAFORM_SHA256

USER root

RUN apk add --update ca-certificates

USER $USER

COPY --from=build /bin/terraform /usr/local/bin/terraform

VOLUME ["/app"]
WORKDIR "/app"
