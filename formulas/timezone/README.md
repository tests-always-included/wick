Timezone
========

Sets the time zone to a specified zone, defaulting to UTC.

* $1 - Optional time zone identifier.  Defaults to `Etc/UTC` for Debian/Ubuntu and `UTC` for all others.

The actions of this formula are based heavily on [timezone-ii](https://github.com/L2G/timezone-ii), a Chef recipe.

Examples

      # Set to UTC
      wickFormula timezone

      # Set to CST6CDT
      wickFormula CST6CDT

Returns nothing.


`timezoneUpdateLocaltime()`
---------------------------

Updates the localtime file.

* $1 - Time zone
* $2 - File to update
* $3 - Use a symlink when this is a non-empty string

Example:

    timezoneUpdateLocaltime UTC /etc/localtime

Returns 0 on success.


`timezoneUpdateSysconfigClock()`
--------------------------------

Updates the timezone in sysconfig/clock.

* $1 - The new timezone.

Examples

    timezoneUpdateSysconfigClock UTC

Returns nothing.


`timezoneUpdateSysconfigTimezone()`
-----------------------------------

Updates the timezone in /etc/sysconfig/timezone.

* $1 - The new time zone.
* $2 - The zoneinfo directory.

Examples

    timezoneUpdateSysconfigTimezone UTC /usr/share/zoneinfo

Returns nothing.


`timezoneUpdateTimezone()`
--------------------------

Update the timezone file.

* $1 - The new timezone.
* $2 - The file to use.

Examples

    timezoneUpdateTimezone UTC /etc/timezone

Returns nothing.


