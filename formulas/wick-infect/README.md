Wick-Infect - Wick Formula
==========================

Installs a Bash configuration at `/usr/local/lib/wick-infect` that shell scripts can source into their environment in order to get a copy of all of the [library] functions.

    wick-formula wick-infect

* There are no parameters.

This example is for a shell script that can run on the target machine after configuring has been performed.

    #!/bin/bash
    set -e

    # Source the library of functions
    . /usr/local/lib/wick-infect

    # Now the script can download URLs
    wick-get-url http://google.com/ google.html

    # Define a function
    call-my-function() {
        local ARGS_verbose UNPARSED

        ARGS_verbose=""

        # Arguments can be parsed
        wick-parse-arguments UNPARSED "$@"

        if [[ ! -z "$ARGS_VERBOSE" ]]; then
            echo "Verbose mode enabled"
        fi

        # Can pass back values as well
        local "${UNPARSED[0]}" && wick-indirect "${UNPARSED[0]}" "data"
    }

    call-my-function --verbose RESULT


[Library]:  ../../lib/README.md
