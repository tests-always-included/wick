Formulas - Wick
===============

Formulas are sets of instructions that result in a specific state.  You use them to install software, configure services and perform other actions in a system.  Formulas may contain dependencies, explorers, files, functions, a run script and templates.

Formulas should be idempotent, which means that running them once or running them a hundred times will result in the exact same state.  Let's take a formula that adds a line to `/etc/rc.local`.  When executed once, the line should be added.  When executed again, the formula should check to see if the line already exists and will add the line only if it is missing.


Specific Formulas
-----------------

See the formula-specific documentation that explain what each of these do.  Formulas can reference each other in the chain of [parents] in the invocation of `wick`.

* [apache2] - Install and configure Apache2
* [hostname] - Set the machine's host and domain
* [mo] - Bash-only templating system that plugs into our templates
* [rvm] - Install RVM and can install Ruby as well as gems
* [wick-base] - Handy functions for all of the other formulas
* [wick-infect] - Creates a file that can be sourced by shell scripts
* [wick-init-d-lib] - Easily create init.d style services


Dependencies
------------

The `depends` file exists so you can list the formulas that need to be installed before this formula executes.  For instance, if you have a formula that requires `apache2`, then your `depends` file would look like this:

    #!/bin/bash
    
    wick-formula apache2

The dependencies can also use explorers.  If you need to use rvm on centos and redhat, your `depends` file would contain lines similar to this example.

    #!/bin/bash
    
    wick-explorer OS wick-base os

    case "$OS" in
        centos|redhat)
            wick-formula rvm
            ;;
    esac

While executing, the `depends` script will have `WICK_FORMULA_DIR` set to the path of the currently executing formula.


Explorers
---------

The shell scripts in `explorers/` are executed by `wick-explorer` (a function provided by [wick-base]).  Their mission is to identify some information about the target system.  This example will detect the Linux kernel version.

    #!/bin/bash
    
    set -e
    uname -r

When executed, the output of this will be something like "3.16.0-30-generic".  You can use explorers to determine the currently running operating system, versions of software, if files exist in specific locations or see if some packages are installed (among many other things).  Take a look at the ones provided in [wick-base] to see some that already exist.

Explorer scripts have the full Wick environment, so functions like wick-debug, wick-info (both from [wick-base]) and any other functions defined by earlier formulas are available during script execution.

On success, information should be written to stdout.  Failure would cause Wick to stop and display all of the messages written to stderr.  (See [Bash concepts] for stdout, stderr, success and failure.)


Files
-----

Anything under `files/` is intended to be copied directly to the target system with `install-formula-file` (a function provided by [wick-base]).  They can also be used indirectly, such as with the `apache2-add-vhost` function (from [apache2]).


Functions
---------

The files in `functions/` are sourced into Wick's environment before a formula runs, allowing the `run` script and any formula afterwards to use them.  (See [Bash concepts] for sourcing.)

It is a good idea to include functions to eliminate repeated tasks such as adding users, installing configuration files and managing processes.  Having copious amounts of logging in the functions helps troubleshoot difficulties as well.  You should use `wick-info`, `wick-debug`, `wick-warn` and `wick-error` (all from [wick-base]) to write output.


Run Script
----------

The `run` file is the meat of your formula.  It performs whatever actions are necessary in order to complete the desired action.  Typically you will leverage existing functions as much as possible in order to keep the size of your code down and to reduce duplication.

The run script should run with `set -e` to make sure that errors cause the script to immediately fail.  It can also be passed arguments.  For instance, the [hostname] formula accepts the desired name for the target machine.  Arguments are set in another function's dependencies or in [roles].  They use the command `wick-formula`, like this:

    wick-formula hostname server1.example.com
    
Then the `run` script for the [hostname] formula will get "server1.example.com" as `$1` in the script.

Here is a sample run script that will download a copy of the application from an internal server.  It uses `wick-parse-arguments` to simplify command-line argument parsing (available in [Libraries]).

    #!/bin/bash
    #
    # Download and install the application code from a remote server
    #
    # Parameters:
    #     $1:  Codebase name to download (eg "myApp")
    #
    # Options:
    #     --version:  Version number to download (default: "latest")
    set -e                              # Fail if any command fails
    ARGS_version=""                     # Set a default that's empty
    wick-parse-arguments UNPARSED "$@"  # Parse command-line arguments
    
    # Check to make sure the codebase was passed.
    # Use ${UNPARSED[0]} instead of $1 because $1 might be the --version option.
    if [[ -z "${UNPARSED[0]}" ]]; then
        # Write a message with wick-error
        wick-error "You must specify a codebase to download"
        
        # Return a non-zero code to indicate failure
        exit 1
    fi
    
    # Set names to be used elsewhere
    NAME=${UNPARSED[0]}
    VERSION=${ARGS_version:-latest}
    URL="http://10.0.0.1/installer-files/${NAME}-${VERSION}.tar.gz"
    
    wick-info "Installing $NAME ($VERSION)"
    
    # Remove a previous installation if one exists
    rm -rf /opt/application
    
    # Create directory
    install-directory --owner=root:root --mode=0755 /opt/application
    
    (
        # Use a subshell when changing directories so we don't need
        # to remember where we were and change back at the end.  Changing back
        # is not a requirement, but doing things this way provides a
        # consistent and easy to understand method.
        
        cd /opt/application
        
        wick-debug "Downloading $URL"
        wick-get-url "$URL" application.tar.gz
        
        wick-debug "Extracting"
        tar xfz application.tar.gz --strip=1
        
        rm application.tar.gz
    )

There you have it, a complete `run` script.  It's calling several other functions defined in [formulas] and [libraries].  It even cleans up after itself.  When anything fails, the script will automatically terminate and Wick will stop processing.  It's fairly simple Bash, with the complexities hidden away in functions.  For example, `wick-get-url` will use `curl` or `wget` if available.  You don't need to worry, force the installation nor do the check yourself.  Instead, let that function do the hard work.


Templates
---------

The files contained within the `templates/` folder are extremely similar to the files that are copied verbatim to the target system, but they follow a naming convention and are processed by a template system.

Templates can be used by any function that installs files via `install-formula-file` (from [wick-base]).  Typically you can just pass `--template` to enable template processing.

    # This copies from files/filename.sh to /tmp/filename.sh
    install-formula-file filename.sh /tmp/
    
    # This uses a template in templates/filename.sh and the shell
    # template engine to generate /tmp/filename (no suffix)
    install-formula-file --template filename.sh /tmp/

When the destination is a directory, the template engine suffix is removed before the file is saved.

Template engines can be added by just including the right formulas.  As an example, you can add [mo] as a dependency and then mustache-style templates can be used.


### Mo (.mo)

Enable mustache-style templates by including the [mo] formula.

Example `depends` file:

    #!/bin/bash
    wick-formula mo

Example `run` script:

    #!/bin/bash
    set -e
    export NAME="Betty"
    export LIST=(one two three)
    install-formula-file --template name.mo /tmp
    
Example `templates/name.mo`:

    Your name is {{NAME}}
    {{LIST}}
    Item: {{.}}
    {{/LIST}
    
Example result in `/tmp/name`:

    Your name is Andrew
    Item: one
    Item: two
    Item: three


### Shell (.sh, .bash)

This is the only templating system that exists by default.  It is assumed that the files are shell scripts and the stdout from the shell script will be the contents of the file that will be saved.  If the shell script reports failure, the installation process is aborted.  (See [Bash concepts] for stdout and failure.)

The shell scripts can read from the environment or do anything that shell commands can normally do.

Example `run` script:

    #!/bin/bash
    set -e
    export NAME="Andrew"
    install-formula-file --template name.sh /tmp/
    
Example `templates/name.sh`:

    #!/bin/bash
    echo "Your name is $NAME"

Example result in `/tmp/name`:

    Your name is Andrew


[apache2]: apache2/README.md
[Bash Concepts]: ../doc/bash-concepts.md
[hostname]: hostname/README.md
[Libraries]: ../lib/README.md
[mo]: mo/README.md
[parents]: ../doc/parents.md
[roles]: ../roles/README.md
[rvm]: rvm/README.md
[wick-base]: wick-base/README.md
[wick-infect]: wick-infect/README.md
[wick-init-d-lib]: wick-init-d-lib/README.md