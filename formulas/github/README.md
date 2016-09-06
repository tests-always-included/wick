GitHub
======

Adds functions for interacting with GitHub repositories via GitHub's API.

Example

    wickFormula github

Returns nothing.


`githubGetArchive()`
--------------------

Function retrieves GitHub repository as a tarball.

* $1              - Path to GitHub repository.
* $2              - Destination of tarball. Output to stdout if no destination given.
* --tag=TAG       - Tag name or branch to pull from. Defaults to master.
* --username=USER - Username for private GitHub repositories.
* --password=PASS - Password for private GitHub repositories.

Examples

    # Retrieves a tarball of kyle-long/pyshelf repository from tag v1.0
    # and outputs it to /tmp/pyshelf.tar.gz
    githubGetArchive kyle-long/pyshelf --tag=v1.0 --dest=/tmp/pyshelf.tar.gz

    # Retrieves a tarball of kyle-long/pyshelf and outputs it to stdout
    # which can be piped into tar.
    githubGetArchive kyle-long/pyshelf | tar xz

Returns zero on success, non-zero if there is an error downloading or a missing argument.


`githubGetRelease()`
--------------------

Function retrieves GitHub repository as a tarball.

* $1              - Path to GitHub repository.
* $2              - Destination of release. Output to stdout if no destination given.
* --tag=TAG       - Tag name of release. Defaults to latest release.
* --username=USER - Username for private GitHub repositories.
* --password=PASS - Password for private GitHub repositories.

Examples

    # Retrieves release from quantumew/mustache-cli from tag v0.1 and
    # outputs the file contents to /tmp/mustache-cli.tar.gz
    githubGetRelease quantumew/mustache-cli --tag=v0.1 --dest=/tmp/mustache-cli.tar.gz

    # Retrieves latest release from quantumew/mustache-cli and outputs it
    # to stdout which can be piped into tar.
    githubGetRelease quantumew/mustache-cli | tar xz

Returns zero on success, non-zero if there is an error downloading or a missing argument.


