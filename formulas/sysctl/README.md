Sysctl
======

This adds a function to Wick to set a configuration setting.

    wickFormula sysctl

Now you have access to `sysctl-set` in your `run` files.

    sysctl-set vm.overcommit_memory 1

This configures `sysctl` with the setting as well as sets the line in `/etc/sysctl.conf` for when you restart the machine.
