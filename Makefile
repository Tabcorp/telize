TARGETS = api-service-telize data target

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
RELEASE = "$(GIT_APPVERSION)-$(GIT_COMMITS).$(GIT_BRANCH).$(GIT_REVID_SHORT)"
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
	@mkdir -p api-service-telize/nginx/
	@cp telize api-service-telize/nginx/telize.conf
	@cp *.conf api-service-telize/nginx/

archive: package
	@echo -e "$(GREEN)Archiving the repo to $(ARCHIVE)$(RESET)"
	@tar -cf $(ARCHIVE) api-service-telize/*
	@mkdir target && mv $(ARCHIVE) target/
	@echo "$(RELEASE)" > target/RELEASE.txt

download-data:
	@mkdir -p data
	@wget -P data/ https://geolite.maxmind.com/download/geoip/database/GeoIPv6.dat.gz
	@wget -P data/ https://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
	@wget -P data/ https://download.maxmind.com/download/geoip/database/asnum/GeoIPASNumv6.dat.gz

test-go:
	@touch xunit.xml

#
# Phony targets

.PHONY: clean package pkg pkg/cp archive download-data test-go
