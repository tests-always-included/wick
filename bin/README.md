Binaries - Wick
===============

At the moment, Wick does not have a lot of commands that it can perform, but the structure is in place so other commands can be picked up from any [parent].  There is a help system and a late-initialization callback that can be performed so commands can register themselves with this help system even if the help system has not yet been loaded.


wick-add-command
----------------

Add a command to the help system.  Used within other binaries.  When help text is supplied, the command is displayed with `wick-help`.  Without help text, this command is just loaded as an available command but will be hidden from the generated help message.

This is not expected to be called from the command-line.

    wick-add-command NAME [HELP]

* `NAME`: Name of the command to add
* `[HELP]`: Help text to display.  Optional; if set then it is added to `wick-help`.

Example, used in another binary:

    wick-on-load wick-add-command help "This adds the help command to the help system"


wick-explorer
-------------

Run an explorer on the target machine.  Provide the result (stdout) to the destination environment variable.  Returns the same success/failure as the explorer.  (See [Bash concepts] for stdout, success and failure.)

    wick-explorer DESTINATION FORMULA EXPLORER

* `DESTINATION`: Name of environment variable to assign with a value.
* `FORMULA`: The name of the formula that contains the explorer.
* `EXPLORER`: Exact name of the explorer shell script in the formula.
* Returns success or failure depending on the explorer.  (See [Bash concepts] for return codes.)

Example, used in a formula, role, depends or another binary:

    wick-explorer OS wick-base os

    # Use wick-info or wick-debug instead of echo when possible
    echo "Your OS is $OS"


wick-find
---------

Locate a file in the [parent] chain.  Starts with the youngest descendant and works its way up through the parents.  Used to find formulas and roles.  The result will be a relative path from the current working directory.

    wick-find DESTINATION NAME

* `DESTINATION`: Name of environment variable to assign with a value.
* `NAME`: File or directory to find.
* Returns success if a match was found, failure otherwise.  (See [Bash concepts] for return codes.)

Example, used in a formula, role, depends or another binary:

    if ! wick-find LOCATION roles/test-role; then
        # Use wick-error instead of echo when possible
        echo "test-role not found"
        exit 1
    fi

    # Use wick-info or wick-debug instead of echo when possible
    echo "Location is $LOCATION"


wick-formula
------------

Mark another formula as being required.  Can specify arguments for the formula.  If there is a duplicate entry, only adds the formula once.  If the formula is specified multiple times with different arguments then `wick-formula` reports failure.

    wick-formula NAME [ARGUMENT [...]]

* `NAME`: Formula name to mark as being required.
* `[ARGUMENT]`:  Any specified arguments are all passed to the formula's run file.  (See [formulas] for more about the run file.)
* Returns failure if there was any problem adding the formula, success otherwise.  (See [Bash concepts] for return codes.)

Example, used in a role, depends or another binary:

    wick-formula wick-base
    wick-formula hostname --dynamic app-{{IP}}.example.com


wick-help
---------

Display a generated help message.  In order to add a command to this message, see `wick-add-command`.

    wick-help

* No arguments, does not report failure.

Example, used in another binary to set up a help message:

    wick-on-load wick-add-command "moo" "Moo like a cow"

Example command line usage:

    ~$ wick help
    ... this would display the help message
    ... including the "moo" command
    ~$


wick-load-role
--------------

Locates and loads a role.  If you would like to inherit from a base role, you can use this command to load the base role from another role.

    wick-load-role ROLE [ARGUMENT [...]]

* `ROLE`: Name of a [role], which defines the list of [formulas] to apply to a target.  Multiple roles can be passed.
* `[ARGUMENT]`:  Any specified arguments are all passed to the role.
* Returns failure if there was an issue finding or loading the role.

Example, used in a role, depends or another binary:

    # Load another role
    wick-load-role base-role

    # Pass arguments
    wick-load-role extra-clever-role --smartness=5


wick-provision
--------------

This applies the given roles to the current machine.  It is not yet able to target a remote machine.

    wick-provision ROLE [...]

* `ROLE`: Name of a [role], which defines the list of [formulas] to apply to a target.  Multiple roles can be passed.
* Returns success if provisioning succeeded, failure otherwise.  (See [Bash concepts] for return codes.)

Example command line usage:

    ~$ wick-provision my-sample-role


[Bash concepts]: ../doc/bash-concepts.md
[Formulas]: ../formulas/README.md
[Parent]: ../doc/parents.md
[Role]: ../roles/README.md
