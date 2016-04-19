github-get-archive
======

Allows you to retrieve git repositories in tar format. By default the archive destination is repository-name.tar.gz.
Usage

    github-get-archive <account> <repository> <tag or branch> [destination] [username] [password]

Add the following to depends

    wickFormula git-get-archive

Example of use

    github-get-archive kyle-long pyshelf v1.0
