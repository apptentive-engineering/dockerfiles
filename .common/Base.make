# Base.make
#
# Generic Makefile symlinked into directories for building images from Dockerfiles.
#
# This Makefile will conditionally detect image dependencies (different dockerfile directories)
# and appropriate include them as target prerequisites.
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

# Generate list of files within local directory that dependencies of the 'build'. If
# any of these files have been changed since the last-modified time on the empty target
# file, it will trigger a rebuild.
BUILD_DEPS := $(shell find -L . -type f \( -iname '*' ! -iname '*build' ! -iname '*deploy' ! -iname '*test' \))

# Recursively search within the dockerfiles directory looking for the build directory
# of the base image (if one is specified/exists). If one does exist, it means there is a
# local image that is the base of this one and it should be included as a dependency.
BASE_IMAGE_DIR := $(shell grep -ril --include=.*  "^IMAGE\s*=\s*$(BASE_IMAGE)$$" $(DOCKERFILES_DIR))
ifeq ($(BASE_IMAGE_DIR),)
BUILD_PREREQUISITES = $(BUILD_DEPS) | build-requirements
CLEAN_PREREQUISITES = | clean-requirements
DEPLOY_PREREQUISITES = build | deploy-requirements
TEST_PREREQUISITES = $(BUILD_DEPS) | test-requirements
else
BUILD_PREREQUISITES = $(BASE_IMAGE)-build $(BUILD_DEPS) | build-requirements
CLEAN_PREREQUISITES = $(BASE_IMAGE)-clean | clean-requirements
DEPLOY_PREREQUISITES = build $(BASE_IMAGE)-deploy | deploy-requirements
TEST_PREREQUISITES = $(BASE_IMAGE)-test $(BUILD_DEPS) | test-requirements

$(BASE_IMAGE)-%:
	$(call TRACE, [$(IMAGE)] - Running '$*' for base image '$(BASE_IMAGE)')
	@$(MAKE) -C $(shell dirname $(BASE_IMAGE_DIR)) $*
	$(call EMPTY_TARGET_BASE_CREATE,$*,$@)
	$(call TRACE, [$(IMAGE)] - Completed '$*' for base image '$(BASE_IMAGE)')
endif

all: test build deploy | all-requirements  ## Build and deploy image created from Dockerfile.

# If the image directory contains a 'skip' file, all targets should be NOOP actions.
SKIPFILE := skip
ifneq ($(strip $(wildcard $(SKIPFILE))),)
build:
	$(NOOP)
clean:
	$(NOOP)
deploy:
	$(NOOP)
test:
	$(NOOP)
else
# If the image directory contains a 'frozen' file, that means we don't want to build it
# because it's deprecated. _However_, it still needs to be linked to the other images in this
# build. In this case, we pull down the latest copy of the image, tag it with context for this
# current build so it can be deployed as part of the group.
#
# If the image directory and contains a 'skip' file, just no-op the build target. This means that
# we don't even want to try and pull down a remote version for this image.
FROZENFILE := frozen
ifeq ($(strip $(wildcard $(FROZENFILE))),)
build: $(BUILD_PREREQUISITES)  ## Build image from Dockerfile.
	$(call TRACE, [$(IMAGE)] - Running '$@')
	$(DOCKER_BUILD)
	$(call EMPTY_TARGET_CREATE,$@)
	$(call TRACE, [$(IMAGE)] - Completed '$@')
else
build: $(BUILD_PREREQUISITES)
	$(call TRACE, [$(IMAGE)] - Running '$@')
	$(call DOCKER_PULL,$(REPO)/$(IMAGE):latest)
	$(call DOCKER_TAG,$(REPO)/$(IMAGE):latest)
	$(call EMPTY_TARGET_CREATE,$@)
	$(call TRACE, [$(IMAGE)] - Completed '$@')
endif

.PHONY: clean
clean: $(CLEAN_PREREQUISITES)  ## Clean state generated by previous images built from Dockerfile.
	$(call TRACE, [$(IMAGE)] - Running '$@')
	$(DOCKER_CLEAN)
	$(EMPTY_TARGET_CLEAN_BUILD)
	$(EMPTY_TARGET_CLEAN_DEPLOY)
	$(EMPTY_TARGET_CLEAN_TEST)
	$(call TRACE, [$(IMAGE)] - Completed '$@')

deploy: $(DEPLOY_PREREQUISITES)  ## Deploy image built from Dockerfile.
	$(call TRACE, [$(IMAGE)] - Running '$@')
	$(DOCKER_DEPLOY)
	$(call EMPTY_TARGET_CREATE,$@)
	$(call TRACE, [$(IMAGE)] - Completed '$@')

test: $(TEST_PREREQUISITES)  ## Test and validate files necessary to build image.
	$(call TRACE, [$(IMAGE)] - Running '$@')
	$(HADOLINT)
	$(call EMPTY_TARGET_CREATE,$@)
	$(call TRACE, [$(IMAGE)] - Completed '$@')
endif

.PHONY: all-requirements
all-requirements: build-requirements deploy-requirements

.PHONY: build-requirements
build-requirements: $(BUILD_REQUIREMENTS)

.PHONY: clean-requirements
clean-requirements: $(CLEAN_REQUIREMENTS)

.PHONY: deploy-requirements
deploy-requirements: build-requirements $(DEPLOY_REQUIREMENTS)

.PHONY: test-requirements
test-requirements: $(TEST_REQUIREMENTS)

requires-%:
	@if [ -z '${${*}}' ]; then echo 'Required variable "$*" not set' && exit 1; fi

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
