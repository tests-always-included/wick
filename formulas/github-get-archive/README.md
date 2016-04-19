github-get-archive
==================

This formula adds a function that allows you to pull down a github repository in tar format.

Usage

    github-get-archive <repository> [tag/branch] [destination] [username] [password]

Example

    github-get-archive kyle-long/pyshelf v1.0 /tmp/pyshelf.tar.gz

    github-get-archive kyle-long/pyshelf | tar xz

Returns nothing.


