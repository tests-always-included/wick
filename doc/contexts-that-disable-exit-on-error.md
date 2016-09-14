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
        echo "It returned a non-zero code, signally false or failure."
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

This can happen in many contexts.  The descrption from [a bug logged](http://austingroupbugs.net/view.php?id=52) to fix the documentation says it can happen for any context including `while`, `until`, `if`, `elif` or `!`.  Below are some examples.  Each of which will output "TEST".

	set -e

    ! true; echo "TEST"

	while false; true; do
		echo "TEST"
		# To prevent an infinit loop
		exit 0
	done

	(set -e; false; true) && echo "TEST"

These are just simple examples.  More complex situations make it harder to spot the problem.
