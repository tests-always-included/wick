Yum-Remi
========

Adds the Remi repository for yum.  Will not make it enabled by default.  Does nothing for other platforms that do not use yum.

    wickFormula yum-remi

In order to use this properly you will need to set an extra environment variable with `wickPackage`.  For example, you install `redis` with this command.

    YUM_ENABLE_REPO="remi" wickPackage redis
