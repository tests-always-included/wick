Add Repo
========

Exposes functions for adding a repository to a package management system.

Examples

    wickFormula add-repo

Returns nothing.


`addRepoApt()`
--------------

External: Adds a repository to apt.  If we find that you are running an operating system that should not be using apt we do not attempt to add it.

Examples

    appRepoApt ppa:bcandrea/consul

Returns true if we are running an operating system that shouldn't use apt or it returns the result of add-apt-repository or apt-get update.


