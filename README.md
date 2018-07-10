# Dockerfiles

[![Build Status](https://travis-ci.org/ahawker/dockerfiles.svg?branch=master)](https://travis-ci.org/ahawker/dockerfiles)

Build a common set of images from Dockerfiles.

## Status

This is under active development and there are a number of patterns not fully well-defined yet.

## Contributing

Adding a new `Dockerfile` to this repo requires an understanding of how the build process works. For building an image from a `Dockerfile`, the build process requires the following:

### Dockerfile

This is just a standard [Dockerfile](https://docs.docker.com/engine/reference/builder/). At a minimum, this should be parameterized with `ARG` instructions for specifying the base image repository, image name and tag. This commonly appears as:

```docker
ARG REPO
ARG BASE_IMAGE
ARG TAG=latest

FROM $REPO/$BASE_IMAGE:$TAG
```

This allows the `Dockerfile` to build off the most recent version of the `BASE_IMAGE` that was created as part of the current build process.

#### Best Practices

It is highly recommended to use `ARG` instructions to parameterize as much of the `Dockerfile` as possible. These values can be injected during the `docker build` process and can be defined in a set of `.env` files. This allows for potential reuse of the `Dockerfile`/`Makefile` combination with any number of `.env` files.

### Makefile

This is just a standard `Makefile` for GNU Make. At a minimum, it needs to define the following targets:

* `all` - Invokes the `build` and then subsequent `deploy` target.
* `build` - Builds a image by injecting build arguments into `docker build` for the local `Dockerfile`.
* `clean` - Cleans up any state created by previous builds, including images stored by the `Docker` daemon.
* `deploy` - Pushes tagged versions of the locally built image to a remote repository.

Beyond defining these targets, the `Makefile` is responsible for the following items:

#### Validation

Validation of build arguments before invoking the `build` and `deploy` targets which call `docker build` and `docker push` respectively. This commonly appears as:

```make
.PHONY: all-requirements
all-requirements: build-requirements deploy-requirements

.PHONY: build-requirements
build-requirements: requires-REPO \
    requires-TAG \
    requires-IMAGE \
    requires-BASE_IMAGE \
    requires-SOME_VARIABLE_IN_ENV_FILE

.PHONY: deploy-requirements
deploy-requirements: requires-REPO \
    requires-TAG \
    requires-IMAGE

requires-%:
    @if [ -z '${${*}}' ]; then echo 'Required variable "$*" not set' && exit 1; fi
```

#### Loading Optional .env Files

If a `.env` file is located within the directory, the `Makefile` is responsible for loading it into the `make` context. Once loaded, these values can be passed in as arguments to the `docker build` command. This commonly appears as:

```make
ENVFILE ?= .env
ifneq ($(strip $(wildcard $(ENVFILE))),)
	include $(ENVFILE)
	export $(shell sed 's/=.*//' $(ENVFILE))
endif
```

#### Base Image Detection

If the `Dockerfile` has a base image dependency that is part of this repository, it is the responsiblity of this `Makefile` to detect the location of the base image and create a phony target dependency on it. This commonly appears as:

**Create recursive all/build/deploy targets for base image**

```make
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
```

**Add base image phony as target to all/build/deploy targets**

```make
.PHONY: all
all: all-requirements build deploy
    ...

build: $(BASE_IMAGE)-build $(BUILD_DEPS) | build-requirements
    ...

.PHONY: deploy
deploy: $(BASE_IMAGE)-deploy $(DEPLOY_DEPS) | deploy-requirements
    ...
```

#### Best Practices

It is highly recommend to define the phony `help` target and set this as the default, enabling users to see supported commands/usage prior to execution. This commonly appears as:

```make
.DEFAULT_GOAL := help

.PHONY: help
help: ## Print Makefile usage.
    @awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
```

## .env Files

An optional `.env` file can be placed in the directory with the `Dockerfile` and `Makefile` to define values for build arguments. This commonly appears as:

```make
# Name of the image created from the Dockerfile.
IMAGE=foobar

# Name of the base image to build on.
BASE_IMAGE=foobar-base

# Version of some package.
PACKAGE_VERSION=1.2.3
```

## TODO's

* CI/CD Pipeline
* Additional tools

## Open Questions

* How to handle reuse of `Dockerfile`/`Makefile` combinations with multiple .env files? (Many to One)
* How to support a `BASE_IMAGE` that is not locally defined?

## Open Documentation Items

* Nested Images
* How to fork

## License

[Apache 2.0](LICENSE)
