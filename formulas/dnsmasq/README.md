Dnsmasq
=======

Installs dnsmasq and adds it as a nameserver.

Examples

    wickFormula dnsmasq

Returns nothing


`dnsmasqAdd()`
--------------

Add a configuration file for dnsmasq into `/etc/dnsmasq.d/`.

* $@ - Passed to `wickMakeFile`

The call to `wickMakeFile` defaults the destination directory for your file.

Examples

    dnsmasqAdd my-sample-config
    dnamasqAdd --template another-sample-config.sh

Returns nothing.


`dnsmasqAddConfig()`
--------------------

Adds a configuration entry into dnsmasq.

* $1   - Name of the rule to generate.
* $2-@ - The configuration line.

The name can be later used by dnsmasqRemove to remove this line.

Examples

    dnsmasqAddConfig consul "server=/consul./127.0.0.1#8600"

Returns nothing.


`dnsmasqRemove()`
-----------------

Removes a configuration file from dnsmasq.

* $1 - Name of file to remove.

Examples

    dnsmasqAdd --template my-config.mo
    dnsmasqRemove my-config

    dnsmasqAddConfig consul "server=/consul./127.0.0.1#8600"
    dnsmasqRemove consul

Returns nothing.


