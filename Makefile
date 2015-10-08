SHELL=/bin/bash
all: bin/README.md lib/README.md formulas/apache2/README.md

bin/README.md: bin/w*
	util/build-readme $@ $@ $(sort $^)

lib/README.md: lib/w*
	util/build-readme $@ $@ $(sort $^)

formulas/%/README.md: formulas/%/functions/*
	util/build-readme $@ $@ $(sort $^)
