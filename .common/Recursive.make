# Recursive.make
#
# Gemeric Makefile responsible for recursively creating targets for all subdirectories.
.DEFAULT_GOAL := help

.SUFFIXES:

ROOT_COMMON_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# Load the common root .default file into the current make context if one exists.
ROOT_COMMON_DEFAULTFILE := $(ROOT_COMMON_DIR)/.default
ifneq ($(strip $(wildcard $(ROOT_COMMON_DEFAULTFILE))),)
include $(ROOT_COMMON_DEFAULTFILE)
export $(shell sed 's/=.*//' $(ROOT_COMMON_DEFAULTFILE))
endif

# Load the common root .env file into the current make context if one exists.
ROOT_COMMON_ENVFILE := $(ROOT_COMMON_DIR)/.env
ifneq ($(strip $(wildcard $(ROOT_COMMON_ENVFILE))),)
include $(ROOT_COMMON_ENVFILE)
export $(shell sed 's/=.*//' $(ROOT_COMMON_ENVFILE))
endif

# Load the common root .custom file into the current make context if one exists.
ROOT_COMMON_CUSTOMFILE := $(ROOT_COMMON_DIR)/.custom
ifneq ($(strip $(wildcard $(ROOT_COMMON_CUSTOMFILE))),)
include $(ROOT_COMMON_CUSTOMFILE)
export $(shell sed 's/=.*//' $(ROOT_COMMON_CUSTOMFILE))
endif

PARENT_COMMON_DIR := $(shell pwd | xargs dirname)/.common

# Load the common parent .default file into the current make context if one exists.
PARENT_COMMON_DEFAULTFILE := $(PARENT_COMMON_DIR)/.default
ifneq ($(strip $(wildcard $(PARENT_COMMON_DEFAULTFILE))),)
include $(PARENT_COMMON_DEFAULTFILE)
export $(shell sed 's/=.*//' $(PARENT_COMMON_DEFAULTFILE))
endif

# Load the common parent .env file into the current make context if one exists.
PARENT_COMMON_ENVFILE := $(PARENT_COMMON_DIR)/.env
ifneq ($(strip $(wildcard $(PARENT_COMMON_ENVFILE))),)
include $(PARENT_COMMON_ENVFILE)
export $(shell sed 's/=.*//' $(PARENT_COMMON_ENVFILE))
endif

# Load the common parent .custom file into the current make context if one exists.
PARENT_COMMON_CUSTOMFILE := $(PARENT_COMMON_DIR)/.custom
ifneq ($(strip $(wildcard $(PARENT_COMMON_CUSTOMFILE))),)
include $(PARENT_COMMON_CUSTOMFILE)
export $(shell sed 's/=.*//' $(PARENT_COMMON_CUSTOMFILE))
endif

# Load the local .env file into the current make context if one exists.
ENVFILE ?= .env
ifneq ($(strip $(wildcard $(ENVFILE))),)
include $(ENVFILE)
export $(shell sed 's/=.*//' $(ENVFILE))
endif

# Load the local .custom file into the current make context if one exists.
CUSTOMFILE ?= .custom
ifneq ($(strip $(wildcard $(CUSTOMFILE))),)
include $(CUSTOMFILE)
export $(shell sed 's/=.*//' $(CUSTOMFILE))
endif

# Load the root .partials files into the current make context if they exist.
# This should always happen after loading all necessary .env files so the partials
# have access to the most up-to-date make context.
ROOT_COMMON_PARTIALS_DIR ?= $(ROOT_COMMON_DIR)/partials
ifneq ($(strip $(wildcard $(ROOT_COMMON_PARTIALS_DIR))),)
include $(ROOT_COMMON_PARTIALS_DIR)/*
endif

# Validate existence of core variables required for virtually all actions.
ifndef DOCKERFILES_DIR
$(error Required variable 'DOCKERFILES_DIR' not set)
endif
ifndef BUILD_ID
$(error Required variable 'BUILD_ID' not set)
endif
ifndef BUILD_TS
$(error Required variable 'BUILD_TS' not set)
endif
ifndef BUILD_TS_TOUCH
$(error Required variable 'BUILD_TS_TOUCH' not set)
endif

ALL_ = $(SUBDIRS:%=%-all)
BUILD = $(SUBDIRS:%=%-build)
CLEAN = $(SUBDIRS:%=%-clean)
DEPLOY = $(SUBDIRS:%=%-deploy)
TEST = $(SUBDIRS:%=%-test)

.PHONY: all
all: $(ALL)  ## Run recursive 'make all' to build an deploy all images.
	$(call TRACE, [$(DIRNAME)] - Recursive '$@' complete)

.PHONY: build
build: $(BUILD)  ## Run recursive 'make build' to build all images.
	$(call TRACE, [$(DIRNAME)] - Recursive '$@' complete)

.PHONY: clean
clean: $(CLEAN)  ## Run recursive 'make clean' to clean all images.
	$(call TRACE, [$(DIRNAME)] - Recursive '$@' complete)

.PHONY: deploy
deploy: $(DEPLOY)  ## Run recursive 'make deploy' to deploy all images.
	$(call TRACE, [$(DIRNAME)] - Recursive '$@' complete)

.PHONY: test
test: $(TEST)  ## Run recursive 'make test' to test all images.
	$(call TRACE, [$(DIRNAME)] - Recursive '$@' complete)

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	@$(MAKE) -C $@

.PHONY: $(ALL)
$(ALL):
	$(call TRACE, [$(DIRNAME)] - Running 'all' for child image '$(@:%-all=%)')
	@$(MAKE) -C $(@:%-all=%) all
	$(call TRACE, [$(DIRNAME)] - Completed 'all' for child image '$(@:%-all=%)')

.PHONY: $(BUILD)
$(BUILD):
	$(call TRACE, [$(DIRNAME)] - Running 'build' for child image '$(@:%-build=%)')
	@$(MAKE) -C $(@:%-build=%) build
	$(call TRACE, [$(DIRNAME)] - Completed 'build' for child image '$(@:%-build=%)')

.PHONY: $(CLEAN)
$(CLEAN):
	$(call TRACE, [$(DIRNAME)] - Running 'clean' for child image '$(@:%-clean=%)')
	@$(MAKE) -C $(@:%-clean=%) clean
	$(call TRACE, [$(DIRNAME)] - Completed 'clean' for child image '$(@:%-clean=%)')

.PHONY: $(DEPLOY)
$(DEPLOY):
	$(call TRACE, [$(DIRNAME)] - Running 'deploy' for child image '$(@:%-deploy=%)')
	@$(MAKE) -C $(@:%-deploy=%) deploy
	$(call TRACE, [$(DIRNAME)] - Completed 'deploy' for child image '$(@:%-deploy=%)')

.PHONY: $(TEST)
$(TEST):
	$(call TRACE, [$(DIRNAME)] - Running 'test' for child image '$(@:%-test=%)')
	@$(MAKE) -C $(@:%-test=%) test
	$(call TRACE, [$(DIRNAME)] - Completed 'test' for child image '$(@:%-test=%)')

# Add targets for performing releases only if we're processing the root Makefile.
ifeq ($(MAKELEVEL),0)
.PHONY: patch-release
patch-release: patch-bump push-tags  ## Release new version with next patch version.

.PHONY: minor-release
minor-release: minor-bump push-tags  ## Release new version with next minor version.

.PHONY: major-release
major-release: major-bump push-tags  ## Release new version with next major version.

.PHONY: %-bump
%-bump:
	$(call BUMPVERSION,$*)

.PHONY: push-tags
push-tags:
	@git push && git push --tags
endif

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
