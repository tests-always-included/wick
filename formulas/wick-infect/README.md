Wick-Infect
===========

Installs a Bash configuration at `/usr/local/lib/wick-infect` that shell scripts can source into their environment in order to get a copy of all of the [library] functions.

    wickFormula wick-infect

* There are no parameters.

This example is for a shell script that can run on the target machine after configuring has been performed.

    #!/usr/bin/env bash

    # Source the library of functions
    . /usr/local/lib/wick-infect

    # Enable strict mode to be safe
    wickStrictMode

    # Now the script can download URLs
    wickGetUrl http://google.com/ google.html

    # Define a function
    call-my-function() {
        local TARGET VERBOSE

        wickGetOption VERBOSE verbose "$@"
        wickGetArgument TARGET 0 "$@"

        if [[ ! -z "$VERBOSE" ]]; then
            echo "Verbose mode enabled"
        fi

        # Can pass back values as well
        local "$TARGET" && wickIndirect "$TARGET" "data"
    }

    call-my-function --verbose RESULT


[Library]:  ../../lib/README.md
