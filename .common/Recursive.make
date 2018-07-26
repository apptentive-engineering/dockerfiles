# Image.make
#
# Generic Makefile symlinked into image directories for recursive building child directories.
.DEFAULT_GOAL := help

IMAGE_COMMON_DIR := $(shell pwd)/.common

IMAGE_COMMON_ENVFILE ?= $(IMAGE_COMMON_DIR)/.env
ifneq ($(strip $(wildcard $(IMAGE_COMMON_ENVFILE))),)
	include $(IMAGE_COMMON_ENVFILE)
	export $(shell sed 's/=.*//' $(IMAGE_COMMON_ENVFILE))
endif

ENVFILE ?= .env
ifneq ($(strip $(wildcard $(ENVFILE))),)
	include $(ENVFILE)
	export $(shell sed 's/=.*//' $(ENVFILE))
endif

ifndef DOCKERFILES_DIR
$(error Required variable 'DOCKERFILES_DIR' not set)
endif

LOGGERFILE ?= $(DOCKERFILES_DIR)/.logger
ifneq ($(strip $(wildcard $(LOGGERFILE))),)
	include $(LOGGERFILE)
endif

DIR := $(shell pwd | perl -nle 'print $$& if m{^$(DOCKERFILES_DIR)/\K.*}')
SUBDIRS := $(shell find -L . -mindepth 2 -type f -not -path '*/\.*' -name 'Makefile' | sed -E "s|/[^/]+$$||" | sed "s|^\./||")
ALL = $(SUBDIRS:%=%-all)
BUILD = $(SUBDIRS:%=%-build)
CLEAN = $(SUBDIRS:%=%-clean)
DEPLOY = $(SUBDIRS:%=%-deploy)

.PHONY: all
all: $(ALL)  ## Run recursive 'make all' to build and deploy all images.
	$(call TRACE, [$(DIR)] - Recursive '$@' complete)

.PHONY: build
build: $(BUILD)  ## Run recursive 'make build' to build all images.
	$(call TRACE, [$(DIR)] - Recursive '$@' complete)

.PHONY: clean
clean: $(CLEAN)  ## Run recursive 'make clean' to clean all images.
	$(call TRACE, [$(DIR)] - Recursive '$@' complete)

.PHONY: deploy
deploy: $(DEPLOY)  ## Run recursive 'make deploy' to deploy all images.
	$(call TRACE, [$(DIR)] - Recursive '$@' complete)

.PHONY: $(ALL)
$(ALL):
	$(call TRACE, [$(DIR)] - Running 'all' for child image '$(@:%-all=%)')
	@$(MAKE) -C $(@:%-all=%) all
	$(call TRACE, [$(DIR)] - Completed 'all' for child image '$(@:%-all=%)')

.PHONY: $(BUILD)
$(BUILD):
	$(call TRACE, [$(DIR)] - Running 'build' for child image '$(@:%-build=%)')
	@$(MAKE) -C $(@:%-build=%) build
	$(call TRACE, [$(DIR)] - Completed 'build' for child image '$(@:%-build=%)')

.PHONY: $(CLEAN)
$(CLEAN):
	$(call TRACE, [$(DIR)] - Running 'clean' for child image '$(@:%-clean=%)')
	@$(MAKE) -C $(@:%-clean=%) clean
	$(call TRACE, [$(DIR)] - Completed 'clean' for child image '$(@:%-clean=%)')

.PHONY: $(DEPLOY)
$(DEPLOY):
	$(call TRACE, [$(DIR)] - Running 'deploy' for child image '$(@:%-deploy=%)')
	@$(MAKE) -C $(@:%-deploy=%) deploy
	$(call TRACE, [$(DIR)] - Completed 'deploy' for child image '$(@:%-deploy=%)')

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
