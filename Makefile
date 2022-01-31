BUILD_PATH?=

DOCKER?= docker
DOCKER_IMAGE?= ijacquez/yaul:latest
DOCKER_NAME?= dev

ifeq ($(strip $(SILENT)),)
  ECHO=
else
  ECHO=@
endif
export ECHO

NOCOLOR?=

# $1 -> BUILD_PATH
define macro-check-progname
  @set -e; \
    test -n "$1" || { printf -- "Undefined BUILD_PATH.\n" >&2; exit 1; }; \
    test -e "$1" || { printf -- "\"$1\" does not exist\n" >&2; exit 1; }; \
	test -d "$1" || { printf -- "\"$1\" is not a directory\n" >&2; exit 1; }
endef

# $@ -> Command ...
define macro-run-project
  $(ECHO)$(DOCKER) run --volume=$(shell pwd)/$(BUILD_PATH):/work --rm --name=$(DOCKER_NAME) -it \
    -e SILENT=$(SILENT) \
    -e NOCOLOR=$(NOCOLOR) \
    $(DOCKER_IMAGE)
endef

.PHONY: all
all:
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | \
	awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | \
	sort | \
	grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: copy-template
copy-template:
	$(call macro-run-project) cp -v -r /opt/yaul-examples/_template .

.PHONY: clean
clean:
	@$(call macro-check-progname,$(BUILD_PATH))
	$(call macro-run-project) make clean

.PHONY: build
build:
	@$(call macro-check-progname,$(BUILD_PATH))
	$(call macro-run-project) make
