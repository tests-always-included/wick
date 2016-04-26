GitHub Get Archive
==================

This formula adds a function that allows you to pull down a Github, Inc. repository in tar format.

`github-get-archive()`
--------------------

Function retrieves GitHub repository as a tarball.

* $1              - Path to GitHub repository.

* $2              - Destination of tarball. Output to stdout if no destination given.

* --tag=TAG       - Tag name or branch to pull from. Defaults to master.

* --username=USER - Username for private GitHub repositories.

* --password=PASS - Password for private GitHub repositories.

Examples

	github-get-archive kyle-long/pyshelf --tag=v1.0 --dest=/tmp/pyshelf.tar.gz

	github-get-archive kyle-long/pyshelf | tar xz

Returns nothing.
