Yum-Remi
========

Adds the Remi repository for yum.  Will not make it enabled by default.  Does nothing for other platforms that do not use yum.

In order to use this properly you will need to set an extra environment variable with `wickPackage`.  For example, you install `redis` with this command.

Examples

    # Loading the formula.
    wickFormula yum-remi

    # Enabling the repository while installing a package.
    YUM_ENABLE_REPO="remi" wickPackage redis

Returns nothing.


