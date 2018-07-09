.DEFAULT_GOAL := help

ENVFILE ?= .env
ifneq ($(strip $(wildcard $(ENVFILE))),)
	include $(ENVFILE)
	export $(shell sed 's/=.*//' $(ENVFILE))
endif

export DOCKERFILES_DIR ?= ..

LOGGERFILE ?= $(DOCKERFILES_DIR)/.logger
ifneq ($(strip $(wildcard $(LOGGERFILE))),)
	include $(LOGGERFILE)
endif

SUBDIRS := $(shell find . -mindepth 2 -type f -name 'Makefile' | sed -E "s|/[^/]+$$||" | sed "s|^\./||")
ALL = $(SUBDIRS:%=%-all)
BUILD = $(SUBDIRS:%=%-build)
CLEAN = $(SUBDIRS:%=%-clean)
DEPLOY = $(SUBDIRS:%=%-deploy)

.PHONY: all
all: $(ALL)  ## Run recursive 'make all' to build and deploy all images.
	$(call TRACE, [jre] - Recursive '$@' complete)

.PHONY: build
build: $(BUILD)  ## Run recursive 'make build' to build all images.
	$(call TRACE, [jre] - Recursive '$@' complete)

.PHONY: clean
clean: $(CLEAN)  ## Run recursive 'make clean' to clean all images.
	$(call TRACE, [jre] - Recursive '$@' complete)

.PHONY: deploy
deploy: $(DEPLOY)  ## Run recursive 'make deploy' to deploy all images.
	$(call TRACE, [jre] - Recursive '$@' complete)

.PHONY: $(ALL)
$(ALL):
	$(call TRACE, [jre] - Running 'all' for '$(@:%-all=%)')
	@$(MAKE) -C $(@:%-all=%) all

.PHONY: $(BUILD)
$(BUILD):
	$(call TRACE, [jre] - Running 'build' for '$(@:%-build=%)')
	@$(MAKE) -C $(@:%-build=%) build

.PHONY: $(CLEAN)
$(CLEAN):
	$(call TRACE, [jre] - Running 'clean' for '$(@:%-clean=%)')
	@$(MAKE) -C $(@:%-clean=%) clean

.PHONY: $(DEPLOY)
$(DEPLOY):
	$(call TRACE, [jre] - Running 'deploy' for '$(@:%-deploy=%)')
	@$(MAKE) -C $(@:%-deploy=%) deploy

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
