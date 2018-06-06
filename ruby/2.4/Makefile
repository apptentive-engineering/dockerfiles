.DEFAULT_GOAL := help

ENVFILE ?= .env
include $(ENVFILE)
export $(shell sed 's/=.*//' $(ENVFILE))

export DOCKERFILES_DIR ?= ..

DEPS := $(shell grep -ril "^IMAGE=\"$(BASE_IMAGE)\"" $(DOCKERFILES_DIR) | xargs dirname)
ALL = $(DEPS:%=%-all)
BUILD = $(DEPS:%=%-build)
DEPLOY = $(DEPS:%=%-deploy)

.PHONY: $(ALL)
$(ALL):
	@$(MAKE) -C $(@:%-all=%) all

.PHONY: $(BUILD)
$(BUILD):
	@$(MAKE) -C $(@:%-build=%) build

.PHONY: $(DEPLOY)
$(DEPLOY):
	@$(MAKE) -C $(@:%-deploy=%) deploy

.PHONY: all
all: all-requirements $(BUILD) build $(DEPLOY) deploy  ## Build and deploy image created from Dockerfile.

.PHONY: build
build: build-requirements $(BUILD)  ## Build image from Dockerfile.
	@docker build \
		--rm \
		--force-rm \
		--tag $(REPO)/$(IMAGE):$(TAG) \
		--tag $(REPO)/$(IMAGE):$(RUBY_VERSION) \
		--tag $(REPO)/$(IMAGE):latest \
		--build-arg REPO=$(REPO) \
		--build-arg TAG=$(TAG) \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg RUBY_VERSION=$(RUBY_VERSION) \
		--build-arg RUBY_GEM_VERSION=$(RUBY_GEM_VERSION) \
		--build-arg GEMS_VERSION=$(GEMS_VERSION) \
		--build-arg BUNDLER_VERSION=$(BUNDLER_VERSION) \
		--build-arg ALPINE_RUBY_PACKAGE_NAME=$(ALPINE_RUBY_PACKAGE_NAME) \
		--build-arg ALPINE_RUBY_PACKAGE_VERSION=$(ALPINE_RUBY_PACKAGE_VERSION) \
		.

.PHONY: deploy
deploy: deploy-requirements $(DEPLOY)  ## Deploy image built from Dockerfile.
	@docker push $(REPO)/$(IMAGE):$(TAG)
	@docker push $(REPO)/$(IMAGE):$(RUBY_VERSION)
	@docker push $(REPO)/$(IMAGE):latest

all-requirements: build-requirements deploy-requirements

build-requirements: requires-REPO \
	requires-TAG \
	requires-IMAGE \
	requires-BASE_IMAGE \
	requires-RUBY_VERSION \
	requires-RUBY_GEM_VERSION \
	requires-GEMS_VERSION \
	requires-BUNDLER_VERSION \
	requires-ALPINE_RUBY_PACKAGE_NAME \
	requires-ALPINE_RUBY_PACKAGE_VERSION

deploy-requirements: requires-REPO \
	requires-TAG \
	requires-IMAGE \
	requires-RUBY_VERSION

requires-%:
	@if [ -z '${${*}}' ]; then echo 'Required variable "$*" not set' && exit 1; fi

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
