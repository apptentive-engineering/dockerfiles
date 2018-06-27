.DEFAULT_GOAL := help

ENVFILE ?= .env
include $(ENVFILE)
export $(shell sed 's/=.*//' $(ENVFILE))

export DOCKERFILE ?= Dockerfile
export DOCKERFILES_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

export COMMIT ?= $(shell git rev-parse --short HEAD)
export BUILD_TS := $(shell date -u +%s)
export BUILD_TS_TOUCH := $(shell date -r $(BUILD_TS) '+%Y%m%d%H%M.%S')
export BUILD_ID ?= $(BUILD_TS)
export TAG ?= $(COMMIT)-$(BUILD_ID)

SUBDIRS := $(shell find . -mindepth 2 -type f -name 'Makefile' | sed -E "s|/[^/]+$$||" | sed "s|^\./||")
ALL = $(SUBDIRS:%=%-all)
BUILD = $(SUBDIRS:%=%-build)
DEPLOY = $(SUBDIRS:%=%-deploy)

.PHONY: all
all: all-requirements $(ALL)  ## Run recursive 'make all' to build and deploy all images.

.PHONY: build
build: $(BUILD) | build-requirements  ## Run recursive 'make build' to build all images.

.PHONY: deploy
deploy: deploy-requirements $(DEPLOY)  ## Run recursive 'make deploy' to deploy all images.

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	@$(MAKE) -C $@

.PHONY: $(ALL)
$(ALL):
	@$(MAKE) -C $(@:%-all=%) all

.PHONY: $(BUILD)
$(BUILD):
	@$(MAKE) -C $(@:%-build=%) build

.PHONY: $(DEPLOY)
$(DEPLOY):
	@$(MAKE) -C $(@:%-deploy=%) deploy

all-requirements: build-requirements deploy-requirements

build-requirements: requires-REPO \
	requires-COMMIT \
	requires-BUILD_ID \
	requires-TAG \
	requires-DOCKERFILES_DIR

deploy-requirements: requires-REPO \
	requires-TAG

requires-%:
	@if [ -z '${${*}}' ]; then echo 'Required variable "$*" not set' && exit 1; fi

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
