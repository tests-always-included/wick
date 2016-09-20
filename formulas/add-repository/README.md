Add Repository
==============

Exposes functions for adding a repository to a package management system.

Examples

    wickFormula add-repository

Returns nothing.


`addRepositoryApt()`
--------------------

Adds a repository to apt.  If we find that you are running an operating system that should not be using apt we do not attempt to add it.

* $1 -  The name of repository you would like to add.

Examples

    addRepositoryApt ppa:bcandrea/consul

Returns true if we are running an operating system that shouldn't use apt or it returns the result of add-apt-repository or apt-get update.


