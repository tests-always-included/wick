github-get-archive
==================

This formula adds a function that allows you to pull down a github repository in tar format.

    <repository>        Path to Github repository.

    --tag=TAG           Tag name or branch to pull from. Defaults to master.

    --dest=DEST         Destination of tarball. Output to stdout if no destination given.

    --username=USER     Username for private Github repositories.

    --password=PASS     Password for private Github repositories.

Example

    github-get-archive kyle-long/pyshelf --tag=v1.0 --dest=/tmp/pyshelf.tar.gz

    github-get-archive kyle-long/pyshelf | tar xz

Returns nothing.


