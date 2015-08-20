Timezone Formula
================

Sets the time zone to a specified zone, defaulting to UTC.

    wick-formula [TIMEZONE]

* `TIMEZONE`: Time zone identifier.  Defaults to `Etc/UTC` for Debian/Ubuntu, `UTC` for all others.

The actions of this formula are based heavily on [timezone-ii](https://github.com/L2G/timezone-ii), a Chef recipe.

Example:

    # Set to UTC
    wick-formula timezone

    # Set to CST6CDT
    wick-formula CST6CDT
