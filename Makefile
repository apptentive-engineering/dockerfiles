.DEFAULT_GOAL := help

ENVFILE ?= .env
ifneq ($(strip $(wildcard $(ENVFILE))),)
	include $(ENVFILE)
	export $(shell sed 's/=.*//' $(ENVFILE))
endif

export DOCKERFILES_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

LOGGERFILE ?= $(DOCKERFILES_DIR)/.logger
ifneq ($(strip $(wildcard $(LOGGERFILE))),)
	include $(LOGGERFILE)
endif

ifeq ($(CI), true)
export BUILD_ID
export BUILD_TS
export BUILD_TS_TOUCH := $(shell date --date="@$(BUILD_TS)" '+%Y%m%d%H%M.%S')
else
export BUILD_ID := $(shell head -n512 /dev/urandom | cksum | cut -f1 -d ' ')
export BUILD_TS := $(shell date -u +%s)
export BUILD_TS_TOUCH := $(shell date -r $(BUILD_TS) '+%Y%m%d%H%M.%S')
endif
export COMMIT ?= $(shell git rev-parse --short HEAD)
export TAG ?= $(COMMIT)-$(BUILD_TS)-$(BUILD_ID)

SUBDIRS := $(shell find . -mindepth 2 -type f -name 'Makefile' | sed -E "s|/[^/]+$$||" | sed "s|^\./||")
ALL = $(SUBDIRS:%=%-all)
BUILD = $(SUBDIRS:%=%-build)
CLEAN = $(SUBDIRS:%=%-clean)
DEPLOY = $(SUBDIRS:%=%-deploy)

.PHONY: all
all: all-requirements $(ALL)  ## Run recursive 'make all' to build and deploy all images.
	$(call TRACE, [root] - Recursive '$@' complete)

.PHONY: build
build: $(BUILD) | build-requirements  ## Run recursive 'make build' to build all images.
	$(call TRACE, [root] - Recursive '$@' complete)

.PHONY: deploy
deploy: deploy-requirements $(DEPLOY)  ## Run recursive 'make deploy' to deploy all images.
	$(call TRACE, [root] - Recursive '$@' complete)

.PHONY: clean
clean: $(CLEAN)  ## Run recursive 'make clean' to clean all image directories.
	$(call TRACE, [root] - Recursive '$@' complete)

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	@$(MAKE) -C $@

.PHONY: $(ALL)
$(ALL):
	$(call TRACE, [root] - Running 'all' for child image '$(@:%-all=%)')
	@$(MAKE) -C $(@:%-all=%) all
	$(call TRACE, [root] - Completed 'all' for child image '$(@:%-all=%)')

.PHONY: $(BUILD)
$(BUILD):
	$(call TRACE, [root] - Running 'build' for child image '$(@:%-build=%)')
	@$(MAKE) -C $(@:%-build=%) build
	$(call TRACE, [root] - Completed 'build' for child image '$(@:%-build=%)')

.PHONY: $(CLEAN)
$(CLEAN):
	$(call TRACE, [root] - Running 'clean' for child image '$(@:%-clean=%)')
	@$(MAKE) -C $(@:%-clean=%) clean
	$(call TRACE, [root] - Completed 'clean' for child image '$(@:%-clean=%)')

.PHONY: $(DEPLOY)
$(DEPLOY):
	$(call TRACE, [root] - Running 'deploy' for child image '$(@:%-deploy=%)')
	@$(MAKE) -C $(@:%-deploy=%) deploy
	$(call TRACE, [root] - Completed 'deploy' for child image '$(@:%-deploy=%)')

.PHONY: all-requirements
all-requirements: build-requirements deploy-requirements

.PHONY: build-requirements
build-requirements: requires-REPO \
	requires-COMMIT \
	requires-BUILD_ID \
	requires-TAG \
	requires-DOCKERFILES_DIR

.PHONY: deploy-requirements
deploy-requirements: requires-REPO \
	requires-TAG

requires-%:
	@if [ -z '${${*}}' ]; then echo 'Required variable "$*" not set' && exit 1; fi

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
