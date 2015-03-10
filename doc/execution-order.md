Execution Order of Formulas
===========================

The way that Wick loads and runs formulas can be a bit tricky to diagnose if you don't understand what's going on.  This document will give you the order of events and the reason behind why those events are happening in this order.

See the [parents] documentation for more information about the hierarchical order in which each item is loaded.  For instance, the library functions load the top most ancestor and works its way down through the children.

1.  [Libraries] are loaded.  They don't have any dependencies other than themselves and they don't care about the order in which they are loaded.

2.  [Binaries] are loaded.  They rely on functions that `wick` exposes and can use the functions in the libraries.  There is a special hook that they can use to call functions after all binaries have been sourced into the environment.  The help system relies on this hook.

3.  A command is executed.  Each command gets its own section.


wick help
---------

Nothing more is loaded for the help system.  This merely writes out messages to stdout.  (See [Bash concepts] for stdout.)


wick run
--------

1.  Execute each of the [roles].  Each role will load more roles or use `wick-formula` to load [formulas].
2.  `wick-formula` will do the following:
    1.  Make sure the formula is not already in the list of formulas to load.
    2.  Run the `depends` file to pick up additional formulas that need to be loaded before this formula.  This calls `wick-formula` and is recursive.
    3.  Add the formula's `run` script if one exists.
    4.  Loads all functions for the formula.
    5.  Run all explorers for the formula.
3.  For each of the [formulas] that need to run:
    1.  Set up a clean subshell.
    2.  Run the formula's `run` script.


[Bash Concepts]: bash-concepts.md
[Binaries]: ../bin/README.md
[Formulas]: ../formulas/README.md
[Libraries]: ../lib/README.md
[Parents]: parents.md
[Roles]: ../roles/README.md
