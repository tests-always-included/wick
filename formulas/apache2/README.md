Apache2 - Wick Formula
======================

Installs the Apache 2.x web server and enables named virtual hosts.

    wick-formula apache2

* No options


Functions
---------

### `apache2-add-conf [OPTIONS] FILE`

* `[OPTIONS]`: The same options that you can pass to `wick-make-file`.
* `FILE`: Name of file contained in the formula to add as a configuration file for Apache.

Installs a configuration file and reloads Apache.  See `wick-make-file` in [wick-base] for information regarding paths and further options.


### `apache2-add-vhost [OPTIONS] FILE`

* `[OPTIONS]`: The same options that you can pass to `wick-make-file`.
* `FILE`: Name of file contained in the formula to add as a virtual host for Apache.

Installs a virtual host and reloads Apache.  See `wick-make-file` in [wick-base] for information regarding paths and further options.


[wick-base]: ../wick-base/README.md
