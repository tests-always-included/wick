Bash Strict Mode
================

As found on [another website](http://redsymbol.net/articles/unofficial-bash-strict-mode/), there is a combination of flags that you can enable to enable a sort of strict mode.  This project is using this combination:

    set -eEu -o pipefail
    shopt -s extdebug
    IFS=$'\n\t'
    trap 'wickStrictModeFail $?' ERR

A brief summary of what each option does:

* `set -e`: Exit immediately if a command exits with a non-zero status, unless that command is part a test condition.  On failure this triggers the ERR trap.
    * There are [some contexts](context-that-disable-exit-on-error.md) that will disable this setting.
* `set -E`: The ERR trap is inherited by shell functions, command substitutions and commands in subshells.  This helps us use `wickStrictModeFail` wherever `set -e` is enabled.
* `set -u`: Exit and trigger the ERR trap when accessing an unset variable.  This helps catch typos in variable names.
* `set -o pipefail`: The return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status.  So, `a | b | c` can return `a`'s status when `b` and `c` both return a zero status.  It is easier to catch problems during the middle of processing a pipeline this way.
* `shopt -s extdebug`: Enable extended debugging.  Bash will track the parameters to all of the functions in the call stack, allowing the stack trace to also display the parameters that were used.
* `IFS=$'\n\t'`: Set the "internal field separator", which is a list of characters use for word splitting after expansion and to split lines into words with the `read` builtin command.  Normally this is `$' \t\n'` and we're removing the space.  This helps us catch other issues when we may rely on IFS or accidentally use it incorrectly.
* `trap 'wickStrictModeFail $?' ERR`:  The ERR trap is triggered when a script catches an error.  `wickStrictModeFail` attempts to produce a stack trace to aid in debugging.  We pass `$?` as the first argument so we have access to the return code of the failed command.

This document deals heavily with status codes, conditionals, and other constructs in Bash scripts.  For more information on those, read about [Bash concepts].


OH, BUT WHY?
------------

This sure sounds like it causes many more problems than it solves.  People will say that their scripts complain loudly and now break often.  The normal way of dealing with variables now causes fatal errors in scripts.  Variables that had entire commands now do not execute properly and non-zero status codes are now being reported where they used to just work.

So why use this?

For the same reason that you use `jslint` for testing if JavaScript is good enough or `-Wall` when compiling C code, you want to know when there are problems and you want those problems exposed very early in the process.  Because this software is responsible for configuring

It is important to make sure that we know about and handle all potential errors because this software will be relied upon to automate an administrator's tasks.

For an example of what the stack trace looks like, here is one from a test program I used:

    Error detected - status code 1
    Command:  false
    Location:  ./in-functions, line 13
    Stack Trace:
        [1] two(): ./in-functions, line 13 -> two 2 22 Two
        [2] one(): ./in-functions, line 8 -> one One\ one\ one\ long\ argument 1-another
        [3] main(): ./in-functions, line 17 -> main

You can see the filename, line number and the name of the function that was called.  The exact command is also preserved and is shown after the arrow on the right.  At the top you can see that there is a status code displayed and the command which actually failed (it was executing `false`).  If this was in a pipeline you would see the pipe status for each command in the pipeline.


Common Problems and Solutions
-----------------------------

When you enable strict mode, it will gladly show you many errors and happily kill your program.  Bash doesn't apparently have any feelings and doesn't care about a programmer's emotional state, but we do.  Here's many common problems and ways to correct them.


### The script terminates early

Whenever any command fails, a script will terminate.  For instance, you could have this command to remove lines saying "REMOVE".

    grep -v "REMOVE" old-file.txt > new-file.txt

If there are no lines with "REMOVE", then `grep` will return a non-zero status code, causing an abrupt termination of the program.  To solve this we have several techniques.

    # Option 1
    # Try to use it in a condition
    if grep -v "REMOVE" old-file.txt > new-file.txt; then
        wickDebug "One or more lines were removed"
    else
        wickDebug "No lines were found"
    fi


    # Option 2
    # Ignore failures entirely for one command
    grep -v "REMOVE" old-file.txt > new-file.txt || true


### Failures in pipes

You may send data through some sort of formatting utility, similar to this:

    myProgram | formatter

The `formatter` command is pretty simple and will always return 0 (success).  Your command seems to fail even though formatter always succeeds and that's because the return code from `myProgram` is not zero.

To counter this issue, you really want to ignore the return value from `myProgram`.

    # You can ignore just the return code for myProgram
    (myProgram || true) | formatter

    # You can ignore the return code for the whole line
    myProgram | formatter || true

The better option is to ignore only the return code for `myProgram`.  That way errors from other parts of the line can still be caught.


### `Unbound variable $1` and optional parameters

With `set -u` enabled, you are unable to use positional parameters that are not defined.  Let's say you have a function that will `echo` the first parameter.

    # This is the old function
    function echoFirst() {
        echo $1
    }

When you run `echoFirst` with no arguments, the above will fail.  To adapt this you should do one of two things.

    # You can default to an empty value, which is similar to how Bash
    # would interpret this without set -u
    function echoFirst() {
        echo ${1-}
    }

    # Alternately you can test for the number of arguments
    function echoFirst() {
        if [[ $# -gt 0 ]]; then
            echo $1
        fi
    }

Strangely enough, `$@` will never give an error even in strict mode.

    # This always works
    function showArgs() {
        echo "$@"
    }

    showArgs one two three
    showArgs  # I would expect this to fail and it does not


### `Unbound variable ${ARRAY[@]}`

When working with arrays, Bash exhibits some odd behavior and it varies based on what version of Bash is being used.

    # This will sometimes break, depending on the version of Bash.
    # The intended behavior is to have this code break.
    ARR=();
    echo "All elements in the array:" "${ARR[@]}"

    # Yes, it will fail even though ARR is defined.  Because it is an empty
    # array, Bash treats it as undefined.

    # Option 1
    # Wrap in a conditional
    if [[ ${#ARR[@]} -gt 0 ]]; then
        echo "All elements in the array:" "${ARR[@]}"
    fi

    # Option 2
    # Substitute an empty value.  This sends an empty string as a
    # second argument to echo.  This technique would potentially
    # cause problems with other functions.
    echo "All elements in the array:" "${ARR[@]-}"


### Appending to an array

There are several ways to append values to an array.

    # Define an array
    ARR=()

    # Does not work when ARR is empty
    ARR=("${ARR[@]}" "another value")

    # Use this instead
    ARR[${#ARR[@]}]="another value"


### Getting the return code

We used to be able to run a command and catch its return code.

    # Will fail with strict mode
    someCommandThatMayFail

    if [[ $? -ne 0 ]]; then
        echo "There was a failure that will need to get handled"
    fi

With the strict mode in place it is much harder to do that.  One option is to use `set +e` and then `set -e` again.  There is a function, `wickStrictRun` that does this for you.  A full description is in [library functions](../lib/README.md).

    # Use this syntax
    wickStrictRun RESULT someCommandThatMayFail

    if [[ $RESULT -ne 0 ]]; then
        echo "There was a failure that will need to get handled"
    fi


### Running a command in a variable

Because IFS is changed, this code does not work.

    # Secretly this command relies on IFS.
    CMD="echo one two three"  # Initial command
    CMD="$CMD four"  # Append an argument
    $CMD  # Run the command

    # This command does not rely on IFS
    # Use this instead.
    CMD=(echo one two three)  # Initial command
    CMD[${#CMD[@]}]=four  # Append an argument
    ${CMD[@]}  # Run the command


### Disabling strict mode

Please do not do this unless you have no other option.  When you do, try to only disable specific things.

    # Allow commands to fail silently
    set +e

    # Allow access undefined variables
    set +u

    # Return the status of the last command in a pipe even if
    # an earlier command fails
    set +o pipefail

Normally, you do not need to use `set +E` as that only determines if the ERR trap is inherited or not.  Since `set +e` and `set +u` would both stop the ERR trap from firing, you wouldn't need to worry about the existence of the trap.


[bash concepts]: bash-concepts.md
