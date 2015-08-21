Libraries - Wick
================

The `lib/` directory in a wick contains files that are intended to be sourced into Wick's environment.  (See [Bash concepts] for sourcing.)  Each file should contain only one function and the filename should match the function name.

Library functions are loaded really early in the [execution order], so they must only use other library functions.  They can not reference anything defined in [formulas].  They are also used by [wick-infect] to generate a file that can be sourced into shell scripts on the target machine after configuring.

Libraries from all [parents] are loaded before the children, allowing children to override functions.

Here is a sample `lib/sample-thing`:

    #!/bin/bash

    sample-thing() {
        echo "I am a sample function"
    }

Not too bad.  It also doesn't do much, but other functions exist and you can look at how they operate.  There are helper functions that do [argument processing].  Other functions can manipulate strings (eg. trimming a string or removing all whitespace), generate random filenames, decompress an archive or even run multiple commands in parallel.  Anything you can do in shell is possible in a library function.


wick-argument-string
--------------------

Convert a string into a safely quoted string that's safe to pass around as an argument.  It is unlikely that this will be necessary for most scripting that's performed because one would need to use `eval` to parse this back to the original value.

    wick-argument-string DESTINATION VALUE

* `DESTINATION`: Name of the environment variable that should get the result.
* `VALUE`: Value to escape

Example:

    local LIST SAFE UNSAFE

    UNSAFE="These words are all one argument"
    wick-argument-string SAFE "$UNSAFE"
    set | grep -E "^(UN)?SAFE="

Example output:

    SAFE='These\ words\ are\ all\ one\ argument'
    UNSAFE='These words are all one argument'


wick-array-filter
-----------------

Run a list of values through a filter.  When the filter function returns an error, remove that element from the list.

    wick-array-filter DESTINATION FILTER [ELEMENT [...]]

* `DESTINATION`: Variable name where the final list will be placed.
* `FILTER`: Function or command to run.  Receives the single argument of the list item's value.
* `ELEMENT`: The elements in the list.

Example:

    remove-animals() {
        case $1 in
            dog|cat|cow|moose)
                # Return failure and the elements will be removed
                return 1
        esac

        return 0
    }

    WORDS=(a dog and a cat chased a cow)
    wick-array-filter FILTERED remove-animals "${WORDS[@]}"

    # Prints "a and a chased a"
    # The hyphen is intentional so you can print the array when there
    # are no elements in the array and when `set -u` is enabled.
    echo "${FILTERED[@]-}"


wick-command-exists
-------------------

Tests to see if a command is in the path by calling `which`.  Because some systems report failure in different ways, this is an attempt to abstract away those alternate error messages and provide a consistent interface.

    wick-command-exists COMMAND

* `COMMAND`: Name of the command to execute.  Do not use a full path here; the intent is to search the `PATH` environment variable for the command.
* Returns success if the command is found.

Example:

    if ! wick-command-exists ls; then
        echo 'Oh no, ls does not exist!'
        echo 'How do you list your files?'
        exit 1
    fi


wick-debug
----------

Logging function.  Use this to log every action that formulas can take.  Debug can be enabled by setting the `DEBUG` environment variable.  When enabled, log messages are written to stderr and also passed to the `wick-log` function so they could make it to a log file.  (See [Bash concepts] for more about stderr.)

This also will colorize the output when the `WICK_COLOR` environment variable is set to anything.

    wick-debug MESSAGE

* `MESSAGE`: The text to log.

When `DEBUG` is set to `*`, `all` or `true`, then debug logging is enabled for everything.  An empty value disables logging.  Otherwise `DEBUG` should be a string of function names (separated by spaces) where debug logging is enabled.  Debug logging will be enabled for those functions, including anything they call.

Writing to stderr instead of stdout is intentional.  This way you can still capture stdout and get the expected results even with debugging enabled.

Examples in formulas:

    DEBUG=""  # Disable debug logging
    wick-debug "This is not logged anywhere"

    DEBUG="all" # Enable debug logging
    wick-debug "Installing the-software"
    wick-package the-software

Examples for enabling debugging for command-line arguments:

    # Enable all logging
    DEBUG="true" ./run-my-program

    # Log only wick-get-url and the-other-function
    DEBUG="wick-get-url the-other-function" ./run-my-program


wick-debug-extreme
------------------

Turn on extreme logging.  This will alert you to all commands that run.  When a command returns a non-zero exit code, that also will get reported.

    wick-debug-extreme [stop]

* `stop` - Optional parameter.  When specified, this disables the logging.

Example:

    # This script may have errors, so turn on debugging
    wick-debug-extreme

    if ! grep -q needle haystack.txt; then
        echo "No needle in haystack.txt"
    fi

    # Stop the extreme logging
    wick-debug-extreme stop


wick-error
----------

Logging function.  Use this to log error messages right before you exit the program or return a failure.  All messages are written to stderr.  Log messages are also passed to the `wick-log` function to be logged to a file.  (See `wick-log` for information about log files.  See [Bash concepts] for more about stderr.)

This also will colorize the output when the `WICK_COLOR` environment variable is set to anything.

    wick-error MESSAGE

* `MESSAGE`: The text to log.

Example:

    wick-error "Could not find some vital thing"
    exit 1


wick-get-argument
-----------------

This retrieves a single argument from the list of arguments.  It's similar to `wick-get-option`.  This returns non-options that were passed to a function.

    wick-get-argument DESTINATION INDEX [ARGUMENTS [...]]

* `DESTINATION`: Name of the environment variable that should get the result.
* `INDEX`: The index of the non-option argument.  The first one has the index of `0`.
* `ARGUMENTS`: Command line arguments to parse.  Typically you use `"$0"` in this place.

Significantly better examples are explained in [argument processing].

Example:

    # Get the first non-option and place it into $NAME
    # If the argument does not exist, sets $NAME to ""
    wick-get-argument NAME 0 "$@"


wick-get-arguments
------------------

Grab all non-option arguments and return them as an array.

    wick-get-argument DESTINATION [ARGUMENTS [...]]

* `DESTINATION`: Name of the environment variable that should get the result.
* `ARGUMENTS`: Command line arguments to parse.  Typically you use `"$0"` in this place.

Significantly better examples are explained in [argument processing].

Example:

    # Any non-option arguments are placed into $ARGUMENTS.
    # If there were none, $ARGUMENTS is set to an empty list.
    wick-get-arguments ARGUMENTS "$@"


wick-get-dest
-------------

Converts a destination (either a filename or a folder) into a standard format.

    wick-get-dest VARIABLE DEST_PATH [FILENAME]

* `VARIABLE`: Name of the environment variable where the result is stored.
* `DEST_PATH`: The destination folder or filename.
* `FILENAME`: When the destination is a folder, this is the desired filename.

The returned value will always have a "/" at the end if it signifies a directory and if `FILENAME` was empty.

Examples:

    # Anything ending in a slash is a folder.
    #
    # Result: OUT is "/etc/server.config"
    wick-get-dest OUT /etc/ server.config

    # RESULT: OUT is "/etc/"
    wick-get-dest OUT /etc/

    # When DEST_PATH has no slash and it exists on the filesystem
    # as a folder, this operates the same as above.  Note that a slash
    #
    # Result: OUT is "/etc/server.config"
    wick-get-dest OUT /etc server.config

    # RESULT: OUT is "/etc/"
    wick-get-dest OUT /etc

    # When DEST_PATH has no slash at the end and does not exist
    # as a directory, it is assumed to be a destination file.
    #
    # Result: OUT is "/some/thing/here"
    wick-get-dest OUT /some/thing/here server.config

    # Result: OUT is "/some/thing/here"
    wick-get-dest OUT /some/thing/here


wick-get-iface-ip
-----------------

The the IP address associated with a given network interface.  If no interface is provided, this returns the first IP address listed by `ifconfig`.

    wick-get-iface-ip DESTINATION [IFACE]

* `DESTINATION`: Name of the environment variable that should get the result.
* `[IFACE]`: Network interface name.  (Optional, defaults to first interface listed by `ifconfig`.)
* Returns success if there was an IP associated, failure otherwise.

Example:

    local IP

    if ! wick-get-iface-ip IP tun0; then
        echo "Tunnel is not yet established"
        exit 1
    fi

    echo "Tunnel IP:  $IP"


wick-get-option
---------------

Retrieve a named option from the list of arguments.

    wick-get-option DESTINATION NAME [ARGUMENTS [...]]

* `DESTINATION`: Name of variable where the value will be stored.
* `NAME`: Option's name.  Can optionally have leading hyphens (eg. `--option-name` and `option-name` are both valid).
* `ARGUMENTS`: Arguments that are to be parsed.  Typically this will be `"$@"`.

This splits up single-hyphen options.  Significantly better examples are explained in [argument processing].

Examples:

    # If --verbose=XYZ is passed, VERBOSE will be set to "XYZ".
    # If --verbose= is passed (empty vallue), VERBOSE is set to "".
    # If --verbose is passed without a value, VERBOSE is set to "true".
    # If --verbose is not passed at all, VERBOSE is set to "".
    wick-get-option VERBOSE verbose "$@"

    # Split single-hyphen options:
    # Assuming that -abc is passed in ...
    wick-get-option LETTER_C c "$@"
    wick-get-option LETTER_D d "$@"
    echo "$LETTER_C" # Echos "true"
    echo "$LETTER_D" # Echos nothing


wick-get-options
----------------

Get all options from a list of arguments and return a list without any processing.

    wick-get-options DESTINATION [ARGUMENTS [...]]

* `DESTINATION`: Name of variable where the value will be stored.
* `ARGUMENTS`: Arguments that are to be parsed.  Typically this will be `"$@"`.

This does not split up single-hyphen options.  Significantly better examples are explained in [argument processing].

Examples:

    wick-get-options OPTIONS "$@"
    # OPTIONS is now a list of all options that were passed to the script


wick-get-url
------------

Download a URL, writing it to stdout or optionally saving it to a file.  Uses `curl` or `wget` if installed on the system.

    wick-get-url [--progress] [--timeout=SECONDS] URL [FILENAME]

* `[--progress]`: Show progress information during downloads.  (Optional.)
* `[--timeout=SECONDS]`: Only wait for the given amount of time before giving up.
* `URL`: URL to download.
* `[FILENAME]`: When specified, output will be written to this filename.  If not specified, the URL will be written to stdout.

Example:

    # Download shell script execute it
    wick-get-url --timeout=30 https://get.rvm.io/ | bash

    # Download a large file and show progress information
    wick-get-url --progress http://example.com/large-file.tar.gz /tmp/large-file.tgz


wick-in-array
-------------

Check if a value is in an array.  Returns success if it exists, failure otherwise.

    wick-in-array NEEDLE [ELEMENT [...]]

* `NEEDLE`: Value to seek in the array.
* `[ELEMENT]`: Individual array elements
* Returns success if the NEEDLE is found in the list of ELEMENTs.

Example:

    local LIST

    LIST=(one two three "four four")

    if wick-in-array one "${LIST[@]}"; then
        echo "one is found"
    fi

    if wick-in-array four "${LIST[@]}"; then
        echo "four should not be found"
        echo "'four four' with a space would be found"
    fi

Example result:

    one is found


wick-indirect
-------------

Set a variable in a parent environment to a single string.  This is the mechanism that other functions use to return data to the calling function.

    wick-indirect DESTINATION VALUE

* `DESTINATION`: Name of the environment variable that should get the result.
* `VALUE`: Value to assign

Example:

    # This function just lists 5 files/directories in /tmp
    # and stores the string result in the desired variable.
    temp-files() {
        local VALUE

        VALUE=$(ls /tmp | head -n 5)
        local "$1" && wick-indirect "$1" "$VALUE"
    }

    FILES=""
    temp-files FILES
    echo "$FILES"

Example result:

    a_9789
    config-err-BhlXXp
    d20150217-10973-riqke0/
    d20150217-11044-6yj33c/
    d20150217-11571-14rt04k/


wick-indirect-array
-------------------

Sets a variable in the parent environment to an array.  When you need to return multiple values from a function, this is just like `wick-indirect`, but is a form made for only arrays.

    wick-indirect-array DESTINATION [VALUE [...]]

* `DESTINATION`: Name of the environment variable that should get the result.
* `[VALUE]`: Value to assign

Example:

    # This function just lists 5 files/directories in /tmp
    # and stores the array result in the desired variable.
    temp-files-array() {
        local FILE VALUE

        VALUE=()

        for FILE in /tmp; do
            [[ "${#VALUE[@]}" -lt 5 ]] && VALUE[${#VALUE[@]}]=$FILE
        done

        # Be careful when `set -u` is enabled
        if [[ ${#VALUE[@]} -eq 0 ]]; then
            local "$1" && wick-indirect-array "$1"
            return
        fi

        local "$1" && wick-indirect-array "$1" "${VALUE[@]}"
    }

    FILES=""
    temp-files-array FILES
    echo "Number of files returned:  ${#FILES}"
    echo "File #1:  ${FILES[0]}"

Example result:

    Number of files returned:  5
    File #1:  a_9789


wick-info
---------

Logging function.  Use this to log major chunks of code that are executing.  Informational messages are written to stdout as long as `WICK_LOG_QUIET` is unset or set to an empty value.  See the `wick-log` function for information regarding logfiles.  (See [Bash concepts] for information about stdout.)

This also will colorize the output when the `WICK_COLOR` environment variable is set to anything.

    wick-info MESSAGE

* `MESSAGE`: The text to log.

Examples:

    wick-info "Installing MongoDB"
    wick-package mongodb

    # Disable informational messages here
    WICK_LOG_QUIET=true
    wick-info "This will not get written to screen."
    wick-info "Informational messages can still be written to the log file."
    wick-info "See wick-log for information."


wick-log
--------

Write a message to a file or to logging system.  Used by `wick-debug`, `wick-info`, `wick-warn`, `wick-error`.  Should not be used directly.

    wick-log LOG_LEVEL MESSAGE

* `LOG_LEVEL`: The log level of the message to write.  Supports `DEBUG`, `INFO`, `WARN`, `ERROR`.
* `MESSAGE`: The message to write to the logging file or system.

This uses the `WICK_LOGFILE` environment variable to determine if a message should be written and where it should be written.

When `WICK_LOGFILE` starts with "syslog:", then the log is written to syslogd.  You can specify the syslog facility name after the colon, such as "syslog:mail".  If unspecified, the default facility is "user".

Otherwise, `WICK_LOGFILE` should be set to a filename.  Messages are prefixed with a timestamp.

Examples:

    # Run a command that logs with other Wick functions.
    # Send output to /var/log/messages
    WICK_LOGFILE=/var/log/messages ./your-command

    # Send messages to /var/log/syslog
    WICK_LOGFILE=syslog:daemon ./my-background-thing


wick-on-exit
------------

Run a command when the currently executing script or subshell ends.

    wick-on-exit COMMAND [ARGUMENT [...]]

* `COMMAND`: The command to execute.  Careful, as the current working directory may have changed.
* `[ARGUMENT]`: Optional arguments to pass to the command.

Example:

    # Download a file
    wick-get-url http://example.com/installer.tar.gz /tmp/installer.tar.gz

    # When done, clean it up
    wick-on-exit rm -f /tmp/installer.tar.gz


wick-port-up
------------

Determines if a port is open or not.  Works with TCP and UDP ports.  If the port is open this returns an error code of 0.  If the port is not open it returns 1.  If there are any errors this returns 2 and writes an error message to stderr.  (See [Bash concepts] for error codes and stderr.)

    wick-port-up PROTOCOL PORT_NUMBER

* `PROTOCOL`: `TCP` or `UDP` (lowercase versions allowed).
* `PORT_NUMBER`: The port number to test.

Example:

    # Confirm a web server is listening
    if ! wick-port-up TCP 80; then
        echo "There is no web server listening on port 80."
    fi

    # Wait for a server to start
    wick-service start my-web-server

    if ! wick-wait-for 120 wick-port-up TCP 80; then
        echo "Tried to wait for 2 minutes but nothing listened on port 80"
    fi


wick-prefix-lines
-----------------

Prepend a string before each line in a variable.  Also converts all newlines to Unix-style newlines in case they weren't that way before.

    wick-prefix-lines DESTINATION PREFIX STRING

* `DESTINATION`: Name of environment variable where the result will be stored.
* `PREFIX`: String to add to the beginning of all lines.
* `STRING`: Original string

Example:

    printf -v LINES "one\ntwo\n"
    echo "$LINES"
    echo "-----"
    wick-prefix-lines RESULT "Look:  " "$LINES"
    echo "$RESULT"

Example output:

    one
    two

    -----
    Look:  one
    Look:  two
    Look:


wick-random-string
------------------

Generates a random alphanumeric string.

    wick-random-string DESTINATION LENGTH [CHARACTERS]

* `DESTINATION`: Name of environment variable that should get the random string as its value.
* `LENGTH`: Integer length of string to create.
* `[CHARACTERS]`: When specified, this is the list of allowed characters.  Defaults to lowercase a-z, uppercase A-Z and the numbers 0-9.

Example:

    # Generate a random directory name
    wick-random-string DIRNAME 16
    mkdir /tmp/$DIRNAME

    # Create a hex byte
    wick-random-string HEX 2 0123456789ABCDEF
    echo "Hex byte: $HEX"


wick-safe-variable-name
-----------------------

Change a variable so it is a valid variable in bash.  This is used primarily by argument parsing functions.

    wick-safe-variable-name DESTINATION STRING

* `DESTINATION`: Name of the environment variable that should get the altered string.
* `STRING`: This is the variable we intend to set.

You can't set things like `$ABC-DEF` as a variable easily and so this function will turn that into something that could be an environment variable by replacing illegal characters with an underscore.

Example:

    wick-safe-variable-name FIXED "ABC-DEF"
    echo "$FIXED"  # Outputs "ABC_DEF"


wick-temp-dir
-------------

Creates a temporary directory.  Automatically sets up a hook with `wick-on-exit` to delete the directory when the shell script is finished.

    wick-temp-dir DESTINATION

* `DESTINATION`: Name of environment variable that should get the path of the temporary directory that was created.

Example:

    wick-temp-dir TEMPDIR
    (
        cd TEMPDIR
        wick-get-url http://install.example.com/ installer-script
        . installer-script
    )

    # Directory is automatically removed for you


wick-test-for-options
---------------------

Guarantee that some options are passed to a script.  This is typically used within a role or a formula's `run` or `depends` script.  The error reporter can be overridden so the library function can be used in external scripts as well.  If any options are missing, this function returns an error status code.  (See [Bash concepts] for status codes.)

    wick-test-for-options [REQUIRED] -- [ARGUMENT_LIST]

* `[REQUIRED]`: Arguments that you require.  For any that are missing, the error program will be called.  You may omit they hyphens before the option name.
* `[ARGUMENT_LIST]`: These are the arguments that were passed to your function.  Normally you will use `"$@"` here.
* Environment variable `WICK_TEST_FOR_OPTIONS_FAILURE`: To change the error reporting function, set this variable to the command that should be executed.  The one and only parameter to this will an option that is required but is not specified.

Examples:

    # Test to make sure this function or file received both
    # "access-key" and "secret-key"
    wick-test-for-options access-key secret-key -- "$@"

    # Same as above - you may specify hyphens before options.
    # Either "--" or "" can be used to mark the end of the required options.
    wick-test-for-options --access-key --secret-key "" "$@"

    # Use your own reporter and make sure that both --mom and --dad are set.
    # This would get called once for each option that is missing.
    missing-option() {
        echo "Hey, you need to specify --$1 as an argument"
    }
    WICK_TEST_FOR_OPTIONS_FAILURE=missing-option \
        wick-test-for-options mom dad -- "$@"


wick-wait-for
-------------

Wait a given amount of time for a shell script to return success, waiting 1 second between calls.  If the time elapses without any successful response then this returns failure.  Otherwise this returns success.

    wick-wait-for TIMEOUT COMMAND [ARGUMENTS [...]]

* `TIMEOUT`: Maximum number of seconds to wait for the command to return.  If this timeout is reached, the running command is killed and `wick-wait-for` returns failure.
* `COMMAND`: The command (shell command or function) to run repeatedly until it returns success or until the timeout is reached.
* `ARGUMENTS`: Additional arguments that will be passed to COMMAND.
* Returns success if the command returned success within the given time.

Example:

    /usr/local/bin/some-other-process &

    # Wait up to 30 seconds for a file to exist
    # You must use a shell command here.  Bash built-ins won't work,
    # so use `[` or `test` instead of `[[`.
    if ! wick-wait-for 30 [ -f /var/run/other-process/run.lock ]; then
        echo "file was never created"
        exit 1
    fi


wick-warn
---------

Logging function.  Use this to log when you encounter a problem, but typically only warn for problems you can overcome.  Warning messages are always written to stdout.  See `wick-log` for information about writing log messages to files.  (See [Bash concepts] regarding stdout.)

This also will colorize the output when the `WICK_COLOR` environment variable is set to anything.

    wick-warn MESSAGE

* `MESSAGE`: The text to log.

Example:

    if [[ -f /some/file ]]; then
        wick-warn "File exists when it should not."
        rm /some/file
    fi


[argument processing]: ../doc/argument-processing.md
[Bash concepts]: ../doc/bash-concepts.md
[execution order]: ../doc/execution-order.md
[formulas]: ../formulas/README.md
[parents]: ../doc/parents.md
[wick-infect]: ../formulas/wick-infect/README.md
