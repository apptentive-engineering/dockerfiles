.DEFAULT_GOAL := help

ENVFILE ?= .env
include $(ENVFILE)
export $(shell sed 's/=.*//' $(ENVFILE))

DOCKERFILE ?= Dockerfile
export DOCKERFILES_DIR ?= ..

.PHONY: all
all: all-requirements build deploy  ## Build and deploy image created from Dockerfile.

build: build-requirements $(ENVFILE) $(DOCKERFILE)  ## Build image from Dockerfile.
	@docker build \
		--rm \
		--force-rm \
		--tag $(REPO)/$(IMAGE):$(TAG) \
		--tag $(REPO)/$(IMAGE):latest \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg USR=$(USR) \
		--build-arg GRP=$(GRP) \
		--build-arg UID=$(UID) \
		--build-arg GID=$(GID) \
		--build-arg COMMIT=$(COMMIT) \
		--build-arg BUILD_ID=$(BUILD_ID) \
		--build-arg INIT_VERSION=$(INIT_VERSION) \
		--build-arg MAINTAINER=$(MAINTAINER) \
		.
	@echo $(REPO)/$(IMAGE):$(TAG) > build

.PHONY: deploy
deploy: deploy-requirements  ## Deploy image built from Dockerfile.
	@docker push $(REPO)/$(IMAGE):$(TAG)
	@docker push $(REPO)/$(IMAGE):latest

all-requirements: build-requirements deploy-requirements

build-requirements: requires-REPO \
	requires-TAG \
	requires-IMAGE \
	requires-COMMIT \
	requires-BUILD_ID \
	requires-BASE_IMAGE \
	requires-USR \
	requires-GRP \
	requires-UID \
	requires-GID \
	requires-INIT_VERSION \
	requires-MAINTAINER \
	requires-DOCKERFILE

deploy-requirements: requires-REPO \
	requires-TAG \
	requires-IMAGE

requires-%:
	@if [ -z '${${*}}' ]; then echo 'Required variable "$*" not set' && exit 1; fi

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
