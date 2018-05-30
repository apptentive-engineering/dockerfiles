.DEFAULT_GOAL := help

ENVFILE ?= .env
include $(ENVFILE)
export $(shell sed 's/=.*//' $(ENVFILE))

SUBDIRS := $(shell find . -mindepth 1 -maxdepth 1 -type d -not -path '*\/.*' | sed "s|^\./||")
ALL = $(SUBDIRS:%=%-all)
BUILD = $(SUBDIRS:%=%-build)
DEPLOY = $(SUBDIRS:%=%-deploy)

.PHONY: all
all: $(ALL)  ## Run recursive 'make all' to build and deploy all images.

.PHONY: build
build: $(BUILD)  ## Run recursive 'make build' to build all images.

.PHONY: deploy
deploy: $(DEPLOY)  ## Run recursive 'make deploy' to deploy all images.

.PHONY: $(ALL)
$(ALL):
	@$(MAKE) -C $(@:%-all=%) all

.PHONY: $(BUILD)
$(BUILD):
	@$(MAKE) -C $(@:%-build=%) build

.PHONY: $(DEPLOY)
$(DEPLOY):
	@$(MAKE) -C $(@:%-deploy=%) deploy

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
