git-get-archive
======

Allows you to retrieve git repositries in tarball format. By default destination is /tmp/$repo.

    git-get-archive <account> <repository> <tag or branch> [destination] [username] [password]

Add the following to depends:
    wickFormula git-get-archive

Example of use:
    git-get-archive kyle-long pyshelf v1.0
