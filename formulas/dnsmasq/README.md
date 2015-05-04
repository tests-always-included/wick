Dnsmasq Formula
===============

This adds dnsmasq to your system and makes sure it is prepended as a resolver.

    wick-formula dnsmasq
    

Functions
---------

### `dnsmasq-add [OPTIONS] FILE`

Adds the given configuration file to dnsmasq and restarts dnsmasq.

* `OPTIONS`: Optional arguments that can be used with `wick-make-file` from [wick-base].
* `FILE`: The name of the configuration file

    dnsmasq-add --template consul-dns-settings.mo


### `dnsmasq-add-config FILE "CONFIGURATION LINE"`

Creates a new file called `FILE` whose contents are a single line as specified with this command.  Restarts dnsmasq.

* `FILE`: The name of the file to generate in `/etc/dnsmasq.d/`.
* `"CONFIGURATION LINE"`: The contents of the file to generate.

    dnsmasq-add-config consul "server=/consul./127.0.0.1#8600"


### `dnsmasq-remove FILE`

Removes the dnsmasq configuration and restarts dnsmasq.

* `FILE`: The name of the file to remove from `/etc/dnsmasq.d/`.

    dnsmasq-remove consul


[wick-base]: ../wick-base/README.md