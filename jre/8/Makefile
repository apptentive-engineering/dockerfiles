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
		--tag $(REPO)/$(IMAGE):$(JAVA_VERSION) \
		--tag $(REPO)/$(IMAGE):latest \
		--build-arg REPO=$(REPO) \
		--build-arg TAG=$(TAG) \
		--build-arg JAVA_VERSION=$(JAVA_VERSION) \
		--build-arg JAVA_MAJOR_VERSION=$(JAVA_MAJOR_VERSION) \
		--build-arg JAVA_MINOR_VERSION=$(JAVA_MINOR_VERSION) \
		--build-arg ALPINE_JAVA_PACKAGE_NAME=$(ALPINE_JAVA_PACKAGE_NAME) \
		--build-arg ALPINE_JAVA_PACKAGE_VERSION=$(ALPINE_JAVA_PACKAGE_VERSION) \
		.

.PHONY: deploy
deploy: deploy-requirements  ## Deploy image built from Dockerfile.
	@docker push $(REPO)/$(IMAGE):$(TAG)
	@docker push $(REPO)/$(IMAGE):$(JAVA_VERSION)
	@docker push $(REPO)/$(IMAGE):latest

all-requirements: build-requirements deploy-requirements

build-requirements: requires-REPO \
	requires-TAG \
	requires-IMAGE \
	requires-JAVA_VERSION \
	requires-JAVA_MAJOR_VERSION \
	requires-JAVA_MINOR_VERSION \
	requires-ALPINE_JAVA_PACKAGE_NAME \
	requires-ALPINE_JAVA_PACKAGE_VERSION

deploy-requirements: requires-REPO \
	requires-TAG \
	requires-IMAGE

requires-%:
	@if [ -z '${${*}}' ]; then echo 'Required variable "$*" not set' && exit 1; fi

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
