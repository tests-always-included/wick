Libraries - Wick
================

The `lib/` directory in a wick contains files that are intended to be sourced into Wick's environment.  (See [Bash concepts] for sourcing.)  Each file should contain only one function and the filename should match the function name.

Library functions are loaded really early in the [execution order], so they must only use other library functions.  They can not reference anything defined in [formulas].  They are also used by [wick-infect] to generate a file that can be sourced into shell scripts on the target machine after provisioning.

Libraries from all [parents] are loaded before the children, allowing children to override functions.

Here is a sample `lib/sample-thing`:

    #!/bin/bash
    
    sample-thing() {
        echo "I am a sample function"
    }

Not too bad.  It also doesn't do much, but other functions exist and you can look at how they operate.  The function `wick-parse-arguments` provides a simple argument parser.  Other functions can manipulate strings (eg. trimming a string or removing all whitespace), generate random filenames, decompres an archive or even run multiple commands in parallel.  Anything you can do in shell is possible in a library function.


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


wick-get-iface-ip
-----------------

The the IP address associated with a given network interface.  If no interface is provided, this returns the first IP address listed by `ifconfig`.

    wick-get-iface-ip DESTINATION [IFACE]

* `DESTINATION`: Name of the environment variable that should get the result.
* `[IFACE]`: Network interface name.  (Optional, defaults to first interface listed by `ifconfig`.)
* Returns success if there was an IP associated, failure otherwise.

Example:

    local IP
    
    if ! wick-get-iface-ip tun0; then
        echo "Tunnel is not yet established"
        exit 1
    fi
    
    echo "Tunnel IP:  $IP"


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
            [[ "${#VALUE[@]}" -lt 5 ]] && VALUE=("${VALUE[@]}" "$FILE")
        done
        
        local "$1" && wick-indirect-array "$1" "${VALUE[@]}"
    }
    
    FILES=""
    temp-files-array FILES
    echo "Number of files returned:  ${#FILES}"
    echo "File #1:  ${FILES[0]}"
    
Example result:

    Number of files returned:  5
    File #1:  a_9789


wick-parse-arguments
--------------------

Parses a list of arguments from the command line.  Sets environment variables for any short (`-a -b` or `-ab`) and long (`--option`) options.  Returns non-option values in an array.  Long options may take a value, such as `--option=value`.

    wick-parse-arguments DESTINATION [ARGUMENT [...]]

* `DESTINATION`: Name of environment variable to assign as an array of non-option values.
* `[ARGUMENT]`: Each argument that you wish to parse

Example:

    test-parser() {
        local ARGS_a ARGS_b ARGS_verbose UNPARSED
        
        ARGS_a="aaa"
        ARGS_b="bbb"
        ARGS_verbose="verbose"
        wick-parse-arguments UNPARSED "$@"
        
        echo "a=$ARGS_a  b=$ARGS_b  verbose=$ARGS_verbose"
        echo "Unparsed: ${UNPARSED[@]}"
    }
    
    test-parser -a --verbose non-option
    test-parser one two three -ab --verbose="moo"

Example result:

    a=true  b=bbb  verbose=true
    Unparsed: non-option
    a=true  b=true  verbose=moo
    Unparsed: one two three


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


[Bash concepts]: ../doc/bash-concepts.md
[execution order]: ../doc/execution-order.md
[formulas]: ../formulas/README.md
[parents]: ../doc/parents.md
[wick-infect]: ../formulas/wick-infect/README.md