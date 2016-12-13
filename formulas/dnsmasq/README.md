Dnsmasq
=======

Installs dnsmasq and adds it as a nameserver.

* --start       - Starts the service. If not specified, the service will not be running when the formula finishes.

* --protect-dns - Adds the contents of [protect-dns-resolver-config](files/protect-dns-resolver-config) to `/etc/dhcp/dhclient-enter-hooks` which prevents `resolv.conf` from being corrupt by `make_resolv_conf`. One situation where this occurs is if there is insufficient disc space remaining to write a new `resolv.conf`. This is only a problem if there is a service running as root and can access and ultimately fill the system reserved portion of disc space.

When `--start` is used, `/etc/resolv.conf` is updated to use dnsmasq. Without `--start`, the nameserver entry is not added.  It would be assumed that either the machine will be rebooted (and thus dnsmasq's nameserver entry would be added with the dhclient hook) or `/etc/resolv.conf` will be updated at a later time when dnsmasq is enabled.

Examples

    # Installs dnsmasq.
    wickFormula dnsmasq

    # Installs dnsmasq and starts it immediately.
    wickFormula dnsmasq --start

    # Installs dnsmasq and prevents the corruption of resolv.conf.
    wickFormula dnsmasq --protect-dns

Returns nothing.


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


