TARGETS = api-service-telize target

RESET=\x1b[0m
GREEN=\x1b[32;01m
RED=\x1b[31;01m
YELLOW=\x1b[33;01m

# GIT Variables
GIT_BRANCH = `git rev-parse --abbrev-ref HEAD`
GIT_APPVERSION = `git describe --tags --abbrev=0`
GIT_COMMITS = $(shell git log $(GIT_APPVERSION)..HEAD --oneline | wc -l | tr -d ' ')
GIT_REVID = `git rev-parse HEAD`
GIT_REVID_SHORT = `git rev-parse --short HEAD`
RELEASE = "$(GIT_APPVERSION)-$(GIT_COMMITS)_$(GIT_REVID_SHORT)_$(GIT_BRANCH)"
ARCHIVE_SOURCE = "tabcorp-api-service-telize-$(RELEASE)"

# Set Default Value for NPM registry
npm_registry ?= "http://registry.npmjs.org/"

ARCHIVE = $(ARCHIVE_SOURCE).tar.gz
#
# Clean and build
#

clean:
	@rm -rf $(TARGETS)

#
# RPM package for distribution
#

package: pkg pkg/cp
	@echo -e "$(GREEN)Creating the Package$(RESET)"

pkg:
	@mkdir -p api-service-telize

pkg/cp: pkg
	@mkdir -p api-service-telize/logs/
	@cp telize api-service-telize/
	@cp *.conf api-service-telize/

archive: package
	@echo -e "$(GREEN)Archiving the repo to $(ARCHIVE)$(RESET)"
	@tar -cf $(ARCHIVE) api-service-telize/*
	@mkdir target && mv $(ARCHIVE) target/
	@echo "$(RELEASE)" > target/RELEASE.txt
#
# Phony targets

.PHONY: clean package pkg pkg/cp archive
