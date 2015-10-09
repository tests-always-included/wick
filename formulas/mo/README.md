Mo
==

Installs [mo](https://github.com/tests-always-included/mo) mustache template parser into `/usr/local/bin/` and adds the ability to use "mo" templates with `wickMakeFile` (in the wick-base formula).

Examples

    wickFormula mo

See [templates] for more about the template system.

[templates]: ../../doc/templates.md

Returns nothing.


`moFormulaTemplate()`
---------------------

Template parser for mustache style templates (`.mo` extension).  Writes the parsed content to stdout.

* $1 - Name of file to parse

Examples

    moFormulaTemplate file.mo

Returns nothing.


