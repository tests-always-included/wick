Wick-Infect - Wick Formula
==========================

Installs a Bash configuration at `/usr/local/lib/wick-infect` that shell scripts can source into their environment in order to get a copy of all of the [library] functions.

    wick-formula wick-infect

* There are no parameters.

This example is for a shell script that can run on the target machine after configuring has been performed.

    #!/bin/bash

    # Source the library of functions
    . /usr/local/lib/wick-infect

    # Enable strict mode to be safe
    wick-strict-mode

    # Now the script can download URLs
    wick-get-url http://google.com/ google.html

    # Define a function
    call-my-function() {
        local TARGET VERBOSE

        wick-get-option VERBOSE verbose "$@"
        wick-get-argument TARGET 0 "$@"

        if [[ ! -z "$VERBOSE" ]]; then
            echo "Verbose mode enabled"
        fi

        # Can pass back values as well
        local "$TARGET" && wick-indirect "$TARGET" "data"
    }

    call-my-function --verbose RESULT


[Library]:  ../../lib/README.md
