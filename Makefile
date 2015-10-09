SHELL=/bin/bash
SCRIPTS=bin/w* formulas/*/depends formulas/*/functions/* formulas/*/run lib/w*
.PHONY: clean
all: bin/README.md lib/README.md formulas/README.md formulas/apache2/README.md tags TAGS

bin/README.md: bin/w*
	util/build-readme $@ > $@.tmp
	mv $@.tmp $@

lib/README.md: lib/w*
	util/build-readme $@ > $@.tmp
	mv $@.tmp $@

formulas/README.md: formulas/*/README.md
	util/build-formula-index-readme $@ > $@.tmp
	mv $@.tmp $@

formulas/%/README.md: formulas/%/run formulas/%/functions/*
	util/build-formula-readme $@ > $@.tmp
	mv $@.tmp $@

tags: $(SCRIPTS)
	chmod 755 $(SCRIPTS)
	ctags --recurse $(SCRIPTS)

TAGS: $(SCRIPTS)
	chmod 755 $(SCRIPTS)
	ctags -e --recurse $(SCRIPTS)

clean:
	#
	# This only cleans up the tag files.
	# README.md files are left intentionally.
	#
	rm tags TAGS
