Yum-Remi Formula
================

Adds the Remi repository for yum.  Will not make it enabled by default.  Does nothing for other platforms that do not use yum.

    wick-formula yum-remi

In order to use this properly you will need to set an extra environment variable with `wick-package`.  For example, you install `redis` with this command.

    YUM_ENABLE_REPO="remi" wick-package redis
