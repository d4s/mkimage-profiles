# umbrella mkimage-profiles makefile:
# iterate over multiple goals/arches,
# collect proceedings

# preferences
-include $(HOME)/.mkimage/profiles.mk

# for immediate assignment
ifndef ARCHES
ifdef ARCH
ARCHES := $(ARCH)
else
ARCHES := $(shell arch | sed 's/i686/i586/; s/armv.*/arm/; s/ppc.*/ppc/')
endif
endif
export ARCHES

export PATH := $(CURDIR)/bin:$(PATH)

# supervise target tracing; leave stderr alone
ifdef REPORT
export REPORT_PATH := $(shell mktemp --tmpdir mkimage-profiles.report.XXXXXXX)
POSTPROC := | report-filter > $(REPORT_PATH)
endif

# recursive make considered useful for m-p
MAKE += -r --no-print-directory

DIRECT_TARGETS := help help/distro help/ve help/vm clean distclean check
.PHONY: $(DIRECT_TARGETS)
$(DIRECT_TARGETS):
	@$(MAKE) -f main.mk $@

export NUM_TARGETS := $(words $(MAKECMDGOALS))

# for pipefail
SHELL = /bin/bash

# don't even consider remaking a configuration file
.PHONY: $(HOME)/.mkimage/profiles.mk

# real targets need real work
%:
	@n=1; \
	set -o pipefail; \
	say() { echo "$$@" >&2; }; \
	if [ "$(NUM_TARGETS)" -gt 1 ]; then \
		n="`echo $(MAKECMDGOALS) \
		| tr '[[:space:]]' '\n' \
		| grep -nx "$@" \
		| cut -d: -f1`"; \
		say "** goal: $@ [$$n/$(NUM_TARGETS)]"; \
	fi; \
	for ARCH in $(ARCHES); do \
		if [ "$$ARCH" != "$(firstword $(ARCHES))" ]; then say; fi; \
		say "** ARCH: $$ARCH"; \
		if $(MAKE) -f main.mk ARCH=$$ARCH $@ $(POSTPROC); then \
			if [ -n "$$REPORT" ]; then \
				$(MAKE) -f reports.mk ARCH=$$ARCH; \
			fi; \
		fi; \
	done; \
	if [ "$$n" -lt "$(NUM_TARGETS)" ]; then say; fi

docs:
	@$(MAKE) -C doc
