Node.js
=======

Installs the latest Node.js (not a distribution's packaged version).

* --version - The specific version (or part of a version) you want to install. You may specify `4` for latest of the `4` branch or an exact version number.  This defaults to the latest version of Node.

Installs node.js to the current machine.  The files are installed into `/usr/local/` and symlinks are added to `/usr/`.  Does not use the platform's packaged version and instead downloads it from the source.

Examples

     # Installs the latest version
     wickFormula nodejs

     # Target the most recent version of the 4.x.x branch
     wickFormula nodejs --version=4

     # Installs Node 5.1.x
     wickFormula nodejs --version=5.1

Returns nothing.


