Node.js
=======

Installs the latest Node.js (not a distribution's packaged version). Optionaly you can provide the version to include via the `--version` option.

* `--version` - The specific version (or part of a version) you want to install. You may specify `4` for latest of the `4` branch of an exact version number.

Installs node.js to the current machine.  The files are installed into `/usr/local/` and symlinks are added to `/usr/`.  Does not use the platform's packaged version and instead downloads it from the source.

Examples

     wickFormula nodejs

Or specifying a version:

    wickFormula nodejs --version=4

Returns nothing.
