Parents
=======

The roles and formulas in Wick are not going to be adequate to get your machines up and running.  They are just building blocks.  It is up to you to assemble them into something useful, but you do not need to assemble them into huge, complex structures immediately.  You can have layers, each one defining useful utilities or combining functions to fit a particular need.


Directory Structure and Parent Concept
--------------------------------------

Inside your directory will be a folder or link to its parent.  That one may have another parent, up and up until you get to `wick.  Here is a sample directory structure using symbolic links to point to the parents.  You could just as easily have git submodules or copies of directories.

    # Wick install for client 1, extends extended-wick
    /home/user/client1/
        formulas/
        parent -> ../extended-wick
        roles/

    # Wick install for client 2, extends extended-wick
    /home/user/client2/
        formulas/
        parent -> ../extended-wick
        roles/

    # Useful formulas, extends wick
    /home/user/extended-wick/
        formulas/
        lib/
        parent -> ../wick
        roles/

    # This is a copy of Wick's repository
    /home/user/wick/
        bin/
        doc/
        formulas/
        lib/
        LICENSE.md
        README.md
        roles/
        tests/

Let's look at this another way, like a family tree.

            wick
             |
       extended-wick
             |
       +-----+-----+
       |           |
    client1     client 2

With this arrangement, you can start at client1 and go "up" to its parent, extended-wick.


How It's Used
-------------

The general idea is that any child can override what the parents provide.  This then forces a particular load order.

* [Binaries] and [libraries] provide functions.  Functions can be overridden by simply defining them again, so the parent is loaded before a child.  In our example for client1, the load order would be wick, then extended-wick and finally client1.

* [Formulas] and [roles] are located using `wickFind` and only one is used.  `wickFind` starts looking in the lowest child and works its way up the parent chain.  If we are seeking the "nginx" formula, `wickFind` searches client1, then extended-wick and finally wick.


[Binaries]: ../bin/README.md
[Formulas]: ../formulas/README.md
[Libraries]: ../lib/README.md
[Roles]: ../roles/README.md
