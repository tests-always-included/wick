CTAGS:=$(shell ctags --version 2>/dev/null)
SHELL=/bin/bash
SCRIPTS=bin/w* formulas/*/depends formulas/*/functions/* formulas/*/run lib/w*
.PHONY: clean
FORMULA_READMES=$(patsubst %/./,%/README.md,$(wildcard formulas/*/./))
all: bin/README.md lib/README.md formulas/README.md $(FORMULA_READMES) tags TAGS

bin/README.md: bin/w*
	util/build-readme $@ > $@.tmp
	mv $@.tmp $@

lib/README.md: lib/w*
	util/build-readme $@ > $@.tmp
	mv $@.tmp $@

formulas/README.md: $(FORMULA_READMES)
	util/build-formula-index-readme $@ > $@.tmp
	mv $@.tmp $@

.SECONDEXPANSION:
formulas/%/README.md: formulas/%/run $$(wildcard formulas/%/functions/*) $$(wildcard formulas/%/explorers/*)
	util/build-formula-readme $@ > $@.tmp
	mv $@.tmp $@

perms:
	chmod 755 $(SCRIPTS)

TAGS: $(SCRIPTS) perms
ifdef CTAGS
	ctags -e --recurse $(SCRIPTS)
else
	$(warning ctags is not installed - not building $@)
endif

tags: $(SCRIPTS) perms
ifdef CTAGS
	ctags --recurse $(SCRIPTS)
else
	$(warning ctags is not installed - not building $@)
endif

clean:
	#
	# This only cleans up the tag files.
	# README.md files are left intentionally because we may update just
	# a portion of that file.
	#
	rm tags TAGS
