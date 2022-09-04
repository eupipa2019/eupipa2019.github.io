### Taken and adapted from https://github.com/upbound/build/blob/master/makelib/common.mk

# Remove default suffixes as we dont use them
.SUFFIXES:

# Set the shell to bash always
SHELL := /bin/bash

.PHONY: all
all: install help

define HELPTEXT
Usage: make [make-options] <target> [options]

Common Targets:
    build               Run hugo build process and start the local server.
    help                Show this help info.
    install             Install dependencies. (Default target)
    post                Create a new post. Expects parameter slug.
    submodules          Initialize the Git submodules.
    submodules.update   Pull the latest changes in the Git submodules & commit.
endef
export HELPTEXT

.PHONY: help
help:
	@echo "$$HELPTEXT"

.PHONY: install
install: submodules
	@command -v hugo > /dev/null || brew install hugo

.PHONY: build
localhost_url = http://localhost:1313/
build: install
	@echo "Opening $(localhost_url) in your browser ..."
	@python3 -m webbrowser $(localhost_url) > /dev/null
	@hugo server --buildDrafts

.PHONY: post
post:
	@if [ ! -z "$(slug)" ]; then hugo new post/$(slug)/index.md; fi

.PHONY: submodules
.git/modules/%:
	@git submodule sync
	@git submodule update --init --recursive
submodules: .git/modules/
.PHONY: submodules.update
submodules.update:
	@git submodule update --remote
	@git add themes
	@git commit -m "chore(make): update submodule"

.PHONY: clean
clean: ## Remove all generated resources.
	rm -rf resources/ || true
