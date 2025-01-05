SHELL :=/bin/bash -e -o pipefail
PWD   := $(shell pwd)

PACKAGES := packages/pike packages/pike_talker

.DEFAULT_GOAL := all
.PHONY: all
all: ## build pipeline
all: setup format analyze test dartdoc

.PHONY: precommit
precommit: ## validate the branch before commit
precommit: all

.PHONY: ci
ci: ## CI build pipeline
ci: analyze test

.PHONY: git-hooks
git-hooks: ## install git hooks
	@git config --local core.hooksPath .githooks/

.PHONY: help
help:
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## setup environment
	$(call print-target)
	@fvm dart --disable-analytics
	@fvm flutter config --no-analytics --enable-android --enable-web
	$(call get)

.PHONY: version
version: ## show current flutter version
	$(call print-target)
	@fvm flutter --version

.PHONY: get
get: ## get dependencies
	$(call print-target)
	@fvm flutter pub get
	@for package in $(PACKAGES); do \
  		(cd $$package && fvm flutter pub get); \
  	done

.PHONY: upgrade
upgrade: get ## upgrade dependencies
	$(call print-target)
	@for package in $(PACKAGES); do \
		(cd $$package && fvm flutter pub get); \
	done

.PHONY: outdated
outdated: ## check for outdated dependencies
	$(call print-target)
	@fvm flutter pub outdated
	@for package in $(PACKAGES); do \
		(cd $$package && fvm flutter pub outdated); \
	done

.PHONY: fix
fix: get ## format and fix code
	$(call print-target)
	@for package in $(PACKAGES); do \
		(cd $$package && fvm dart format --fix -l 80 lib/ test/); \
	done

.PHONY: format
format: fix

.PHONY: fmt
fmt: fix

.PHONY: clean
clean: ## remove files created during build pipeline
	$(call print-target)
	@fvm flutter clean
	@rm -rf .dart_tool build coverage .flutter-plugins .flutter-plugins-dependencies
	$(call get)
	@for package in $(PACKAGES); do \
		(cd $$package && fvm flutter clean); \
		(cd $$package && rm -rf .dart_tool build coverage .flutter-plugins .flutter-plugins-dependencies); \
	done

.PHONY: analyze
analyze: get ## check source code for errors and warnings
	$(call print-target)
	@for package in $(PACKAGES); do \
		(cd $$package && fvm dart format --set-exit-if-changed -l 80 -o none lib/ test/); \
		(cd $$package && fvm flutter analyze --fatal-infos --fatal-warnings lib/ test/); \
	done

.PHONY: check
check: analyze

.PHONY: lint
lint: analyze

.PHONY: test
test: ## run tests
	$(call print-target)
	@for package in $(PACKAGES); do \
		(cd $$package && fvm flutter test --color --coverage --concurrency=50 --platform=tester --reporter=compact --timeout=30s); \
	done

.PHONY: coverage
coverage: test ## generate coverage report
	$(call print-target)
	@mkdir -p coverage
	@for package in $(PACKAGES); do \
		(cd $$package && lcov --capture --directory . --output-file coverage/lcov.info); \
	done
	@lcov --add-tracefile coverage/lcov.info --output-file coverage/combined_lcov.info

.PHONY: diff
diff: ## git diff
	$(call print-target)
	@git diff --exit-code
	@RES=$$(git status --porcelain) ; if [ -n "$$RES" ]; then echo $$RES && exit 1 ; fi

define print-target
    @printf "Executing target: \033[36m$@\033[0m\n"
endef

.PHONY: dartdoc
dartdoc: ## generate dart documentation
	$(call print-target)
	dartdoc
	@for package in $(PACKAGES); do \
		(cd $$package && dartdoc); \
	done