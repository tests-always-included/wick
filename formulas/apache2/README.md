Apache2
=======

Installs the Apache 2.x web server and enables named virtual hosts.  Provides functions to add virtual hosts and config files.

Examples

    wickFormula apache2

Returns nothing.


`apache2AddConf()`
------------------

Installs a configuration file and reloads Apache.  See `wickMakeFile` in [wick-base](../wick-base) for information regarding paths and further options.

* $1 - Name of file contained in the formula to add as a configuration file for Apache.
* $@ - All other options pass directly to `wickMakeFile`.

Returns nothing.


`apache2AddVhost()`
-------------------

Installs a virtual host and reloads Apache.  See `wickMakeFile` in [wick-base](../wick-base) for information regarding paths and further options.

* $1 - Name of file contained in the formula to add as a virtual host for Apache.
* $@ - All other options pass directly to `wickMakeFile`.

Returns nothing.


