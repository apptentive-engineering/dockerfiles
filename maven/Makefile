.DEFAULT_GOAL := help

ENVFILE ?= .env
include $(ENVFILE)
export $(shell sed 's/=.*//' $(ENVFILE))

.PHONY: all
all: all-requirements build deploy  ## Build and deploy image created from Dockerfile.

.PHONY: build
build: build-requirements  ## Build image from Dockerfile.
	@docker build \
		--rm \
		--force-rm \
		--tag $(REPO)/$(IMAGE):$(TAG) \
		--tag $(REPO)/$(IMAGE):$(MAVEN_VERSION) \
		--tag $(REPO)/$(IMAGE):latest \
		--build-arg MAVEN_VERSION=$(MAVEN_VERSION) \
		--build-arg ALPINE_MAVEN_PACKAGE_NAME=$(ALPINE_MAVEN_PACKAGE_NAME) \
		--build-arg ALPINE_MAVEN_PACKAGE_VERSION=$(ALPINE_MAVEN_PACKAGE_VERSION) \
		.

.PHONY: deploy
deploy: deploy-requirements  ## Deploy image built from Dockerfile.
	@docker push $(REPO)/$(IMAGE):$(TAG)
	@docker push $(REPO)/$(IMAGE):$(MAVEN_VERSION)
	@docker push $(REPO)/$(IMAGE):latest

all-requirements: build-requirements deploy-requirements

build-requirements: requires-REPO \
	requires-IMAGE \
	requires-MAVEN_VERSION \
	requires-ALPINE_MAVEN_PACKAGE_NAME \
	requires-ALPINE_MAVEN_PACKAGE_VERSION

deploy-requirements: requires-REPO \
	requires-IMAGE \
	requires-MAVEN_VERSION

requires-%:
	@if [ -z '${${*}}' ]; then echo 'Required variable "$*" not set' && exit 1; fi

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
