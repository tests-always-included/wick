Hostname - Wick Formula
=======================

Sets the hostname and domain.  Supports templates.  Can automatically update the hostname on network connections.

    wick-formula hostname [--dynamic] HOSTNAME

* `--dynamic`: Flag indicating that the HOSTNAME should be updated when network connections are created.  This should be used with templated hostnames and does not serve any purpose when the hostname is not templated.
* `HOSTNAME`: Hostname to assign to the machine.  Can be just the "local part" (eg. `machine1`) or a fully qualified name (eg. `machine1.example.com`).  When fully qualified, this also sets the domain name.  Can be templated.

Example:

    wick-formula hostname machine1


Templated Hostnames
-------------------

Templated hostnames can change "app1-{{IP}}.example.com" into "app1-192_168_0_1.example.com".  This is not the same template system that formulas use; it is a simple string replacement.  Templated variables that are supported:

* `{{IP}}`:  Results in a string of the current IP address of the machine, with dots replaced by underscores.

When using templated hostnames, you will likely want to also use `--dynamic` so the name is changed after reboots.

Example:

    wick-formula hostname --dynamic app1-{{IP}}.example.com
