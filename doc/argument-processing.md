Argument Processing - Wick
==========================

There are several functions that will help you parse arguments that are passed into your script.  This document shows real-world scenarios where you can use each of the functions.  For information on how to call them, refer to the [library functions](../lib/README.md).

* `wickGetArgument`
* `wickGetArguments`
* `wickGetOption`
* `wickGetOptions`

It is assumed that scripts here have access to these functions.  They must either be running within a Wick environment or they sourced `/usr/local/lib/wick-infect` from the [`wick-infect` formula](../formulas/wick-infect/README.md).


Options versus Arguments
------------------------

An option is a command-line parameter that looks like `--option-name`, `-v` or `--thing=value`.  They all have a hyphen at the beginning.

Arguments can be options, which can be confusing.  To keep things consistent inside the codebase, `wickGetArgument` and `wickGetArguments` return only non-option arguments, with one caveat:  any options (eg. --thing) is an argument when it occurs after a double-hyphen argument.

Example:

    # This shows options (opt) and arguments (arg)
    # Note how the double hyphen will change everything after it into
    # arguments.
    scriptName --opt -o arg1 --opt2=value arg2 -- --arg3=value -a


Retrieving Single Options
-------------------------

Consider the times when you want a simple flag that would enable features, such as a verbose mode.

    # Find if `--verbose` was passed.
    wickGetOption VERBOSE_FLAG verbose "$@"

    [[ ! -z "$VERBOSE_FLAG" ]] && echo "Verbose mode enabled"

Checking if a flag was passed in seems easy.  It's not any harder to also look for particular values.

    # The --user and --role options are mandatory.
    # Because "set -e" is enabled by default when running scripts,
    # this will exit if there are errors.
    wickTestForOptions user role -- "$@"

    # Get the user and role.
    wickGetOption USER user "$@"
    wickGetOption ROLE role "$@"

    # The --verbose option is optional.
    wickGetOption VERBOSE verbose "$@"

    echo "USER:  $USER"
    echo "ROLE:  $ROLE"

    [[ ! -z "$VERBOSE" ]] && echo "Verbose flag enabled"


Retrieving Single Arguments
---------------------------

Normally one would use `$1` to get the first argument, but arguments to functions could include both options and non-option arguments.  To make sure you get the first non-option argument you would use `wickGetArgument`.

    # Get the first non-option argument and save it as SOURCE.
    # Get the second non-option argument and save it as DESTINATION.
    wickGetArgument SOURCE 0 "$@"
    wickGetArgument DESTINATION 1 "$@"

Please be careful.  The indexing on this command starts at zero.

If there are not enough arguments in `$@` then the variable is set to an empty string.

You can see how useful this is when we start mixing arguments and options.  Let's make a helper function:

    diagnose() {
        wickGetArgument FIRST 0 "$@"
        wickGetArgument SECOND 1 "$@"
        echo "${FIRST}...${SECOND}"
    }

    # In comments I will show you the output of the following commands

    diagnose
    # ...

    diagnose a b
    # a...b

    diagnose a b --option1 --option2
    # a...b

    diagnose --key=value -abc "complex example" --left --right "still works"
    # complex example...still works

That last example really illustrates the goal of these functions.


Passing Arguments Through
-------------------------

Imagine a function that will consume one argument and pass the rest to another function.  Perhaps we get a username as the first argument and a home directory as a second.

    setupUserDir() {
        local ARGS

        # Get a list of all non-option arguments
        wickGetArguments ARGS "$@"

        # Remove the first item from the list
        ARGS=("${ARGS[@]:1}")

        # Pass the remaining arguments to another function
        setupDir "${ARGS[@]}"
    }


Passing Options Through
-----------------------

Let's say you have a function called `setupService` and it wants to support all of the options that `wickMakeFile` supports.

    setupService() {
        local OPTIONS

        wickGetOptions OPTIONS "$@"

        # OPTIONS is now set to a list of all options that were passed
        # in to this function.

        wickMakeMile source-file.txt /dest/folder/ "${OPTIONS[@]}"
    }

To make it more complex, we alter `setupService` to accept a `--reload` parameter but we don't want to pass `--reload` to `wickMakeFile`.

    setupService() {
        local OPTIONS

        wickGetOptions OPTIONS "$@"

        # OPTIONS could have `--reload`
        # This is how we remove items from the array

        wickFilterArray OPTIONS setupServiceOptionsFilter "${OPTIONS[@]}"

        # OPTIONS now will not have `--reload`

        wickMakeFile source-file.txt /dest/folder "${OPTIONS[@]}"
    }

    setupServiceOptionsFilter() {
        case "$1" in
            --reload|reload=*)
                # Return failure and wickFilterArray will remove the
                # value from the list.
                #
                # We match against both --reload and --reload=* because the
                # option could be specified in either way.
                return 1
                ;;
        esac

        # Return success and wickFilterArray preserves the value.
        return 0
    }
