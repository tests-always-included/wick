network-layer
=============

Provides a library that allows you to include services into the network layer. Your service would be added after the rest of the network is up but before the rest of the services that depend on the network.

This could be used, for instance, to bring up a tunnel interface.

CentOS 6 and RedHat 6 have a `$network` virtual service but it is provided directly by `network` without exposing any ability to have `$network` require other services before it's considered "up".  In this case, this  formula will make a virtual `$network` service and overrides the `network` script so it provides `network` instead of `$network`.

Examples

    wickFormula network-layer

Returns nothing.


`networkLayerInclude()`
-----------------------

External: Includes you service into the "network-layer" so that it will run after the normal network is up but before any of the services that depend on the network being up.

* $1 - The name of the service you would like to add.

Examples

      networkLayerInclude tunnel-interface

Returns nothing.


