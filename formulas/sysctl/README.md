Sysctl
======

This adds a function to Wick to set a system configuration setting.

Examples

    wickFormula sysctl

Returns nothing.


`sysctlSet()`
-------------

Changes a system setting.

* $1 - Setting name.
* $2 - Value to assign.

Examples

    sysctlSet vm.overcommit_memory 1

This configures `sysctl` with the setting as well as sets the line in `/etc/sysctl.conf` for when you restart the machine.

Returns nothing.


