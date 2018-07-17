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

SUBDIRS := $(shell find -L . -not -path '*/\.*' -mindepth 2 -type f -name 'Makefile' | sed -E "s|/[^/]+$$||" | sed "s|^\./||")
ALL = $(SUBDIRS:%=%-all)
BUILD = $(SUBDIRS:%=%-build)
CLEAN = $(SUBDIRS:%=%-clean)
DEPLOY = $(SUBDIRS:%=%-deploy)

.PHONY: all
all: $(ALL)  ## Run recursive 'make all' to build and deploy all images.
	$(call TRACE, [python3] - Recursive '$@' complete)

.PHONY: build
build: $(BUILD)  ## Run recursive 'make build' to build all images.
	$(call TRACE, [python3] - Recursive '$@' complete)

.PHONY: clean
clean: $(CLEAN)  ## Run recursive 'make clean' to clean all images.
	$(call TRACE, [python3] - Recursive '$@' complete)

.PHONY: deploy
deploy: $(DEPLOY)  ## Run recursive 'make deploy' to deploy all images.
	$(call TRACE, [python3] - Recursive '$@' complete)

.PHONY: $(ALL)
$(ALL):
	$(call TRACE, [python3] - Running 'all' for child image '$(@:%-all=%)')
	@$(MAKE) -C $(@:%-all=%) all
	$(call TRACE, [python3] - Completed 'all' for child image '$(@:%-all=%)')

.PHONY: $(BUILD)
$(BUILD):
	$(call TRACE, [python3] - Running 'build' for child image '$(@:%-build=%)')
	@$(MAKE) -C $(@:%-build=%) build
	$(call TRACE, [python3] - Completed 'build' for child image '$(@:%-build=%)')

.PHONY: $(CLEAN)
$(CLEAN):
	$(call TRACE, [python3] - Running 'clean' for child image '$(@:%-clean=%)')
	@$(MAKE) -C $(@:%-clean=%) clean
	$(call TRACE, [python3] - Completed 'clean' for child image '$(@:%-clean=%)')

.PHONY: $(DEPLOY)
$(DEPLOY):
	$(call TRACE, [python3] - Running 'deploy' for child image '$(@:%-deploy=%)')
	@$(MAKE) -C $(@:%-deploy=%) deploy
	$(call TRACE, [python3] - Completed 'deploy' for child image '$(@:%-deploy=%)')

.PHONY: help
help: ## Print Makefile usage.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
