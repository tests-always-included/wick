NSCD
====

This installs a name server caching daemon.  The `unscd` package is preferred over `nscd`, but the two are essentially interchangeable.

Examples

    wickFormula nscd

Returns nothing.


`nscdRestart()`
---------------

Restart the nscd or unscd daemon.  This is used whenever you make changes to nsswitch or other times when a cached user hit/miss would cause issues.

Examples

    nscdRestart

Returns nothing.


