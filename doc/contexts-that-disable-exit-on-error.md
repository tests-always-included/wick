Contexts That Disable Exit On Error
===================================

In Wick, everything by default runs in [strict mode](bash-strict-mode.md).  This, among other things, sets `-e` which tells Bash to exit if a command that was ran exited with an error code.  It will also exit with the same error code as the command that failed.

    set -e

    errorCommand() {
        false
    }

    echo "Will see this"
    errorCommand()
    echo "Will not see this"

This will exit with the code 1.  We sometimes use exit codes to our advantage.

    set -e

    errorCommand() {
        false
    }

    if ! errorCommand; then
        echo "It returned a non-zero code, signalling false or failure."
        # continue to do other stuff.
    fi

Most of the time this works fine, but there are situations that might cause confusion.  What the `if` does in this case is disables the `-e` flag which is why it doesn't just exit at that line.


Examples
--------

Here are a few examples that might cause confusion.

    set -e

    errorCommand() {
        false
        echo "shouldn't get here right?"
    }

    if ! errorCommand; then
        echo "Expected failure"
    else
        echo "Didn't expect a success"
    fi

This outputs

    shouldn't get here right?
    Didn't expect a success

Two things to note:

1. Without `-e` `errorCommand` continues even though the first command exited with a non-zero value (`false`).
2. `errorCommand` exits with 0 because the `echo` command successfully completed.

Another thing to note is that there is no way to reenabled `-e` once inside of one of these contexts.  This applies even if you are running a subshell.


    set -e

    if ! (set -e; false; echo "it's fine"); then
        echo "Expected failure"
    else
        echo "Didn't expect a success"
    fi

Which outputs

    Didn't expect a success

This can happen in many contexts.  The description from [a bug logged](http://austingroupbugs.net/view.php?id=52) to fix the documentation says it can happen for any context including `while`, `until`, `if`, `elif` or `!`.  Below are some examples.  Each of which will output "TEST".

	set -e

    ! true; echo "TEST"

	while false; true; do
		echo "TEST"
		# To prevent an infinite loop
		exit 0
	done

	(set -e; false; true) && echo "TEST"

These are just simple examples.  More complex situations make it harder to spot the problem.


How to Fix
----------

There are two options.  This one is great when you are executing a command or a function that acts like a command.  It's for situations where the environment should not change (such as a function that could return a status code and that's it).

    # Change code like this
    if someBashFunction; then

    # Into code like this
    local result

    wickStrictRun result someBashFunction

    if [[ "$result" -eq 0 ]]; then

It is not necessary to make this change when the program being executed is guaranteed to be an external program, like `grep` or `cat`.  Use this when you don't know if you are executing a function or a binary.

Also, if you are executing functions, you could make the function safe to run directly by capturing every possible command that could have stopped execution and forcing the end of the function.

    # Old code
    result=$(ls some-file)
    list=( "some" "words" $(runSomething) )
    grep -q "words" in-this-file
    wickGetIfaceIp ipAddress tun0

    # New code
    result=$(ls some-file) || return $?
    list=( "some" "words" $(runSomething) ) || return $?
    grep -q "words" in-this-file || return $?
    wickGetIfaceIp ipAddress tun0 || return $?
