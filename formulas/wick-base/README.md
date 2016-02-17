Wick-Base
=========

This formula only adds useful functions and explorers to Wick.  Nearly everything depends on this formula.

Instead of building many things into the core of Wick, the choice was made to allow users to override nearly everything.  This includes `wick-base`, putting the power to fix bugs or experiment with new techniques in your repositories before things get published in the official repository.

Examples

    wickFormula wick-base

Returns nothing.


Explorers
=========


### arch

Determines the architecture that the system is running upon.

Detected values:

* `amd64` * `ia32`

Examples

    wickExplorer arch wick-base arch

    if [[ "$arch" != "amd64" ]]; then
        wickError "Sorry, this requires an AMD64 system."
        exit 1
    fi

Returns true when the architecute could be determined.


### bash-version

Writes to stdout the version of Bash in use on the target system.

Examples

    wickExplorer result wick-base bash-version
    echo "$result"  # "4.3.30(1)-release"

Returns nothing.


### machine-type

Finds the type of machine we appear to be using.  Attempts to detect virtualization environments.  This explorer is a bit rudimentary and could be tricked.  Output is written to stdout.

Detected values:

* `amazon`: Running in Amazon AWS * `unknown`: All other results

Examples

    wickExplorer result wick-base machine-type
    if [[ "$result" == "amazon" ]]; then
        echo "I am in Amazon AWS"
    fi


### os

Makes an educated guess to determine the OS that is running.  Writes the OS to stdout for `wickExplorer`.

Detected values:

* `apple`: Mac OS X * `centos`: CentOS * `redhat`: RedHat * `ubuntu`: Ubuntu

Examples

    wickExplorer RESULT wick-base os
    case "$RESULT" in
        apple)
            brew install packageName
            ;;

        redhat)
            yum install packageName
            ;;

        ubuntu)
            apt-get install packageName
            ;;
    esac

Returns 0 on success or 1 when the OS can't be determined.


### os-version

Attempts to find the release version of the distribution that is running.

Example:

    wickExplorer

Returns true on success.


`bashFormulaTemplate()`
-----------------------

Run a Bash shell script as a template.

Examples

    bashFormulaTemplate my-template-file.bash > /tmp/the-result

Returns the status code of the shell script.


`formulaTemplate()`
-------------------

Process a formula's template file.  Automatically detects the template engine by the filename extension.  Writes results to stdout.

This is what `wickMakeFile` may use when processing templates.

The template engine is detected by the file extension.  It will automatically run a function named `extFormulaTemplate` where `ext` is replaced with the file extension.

* $1 - Path to a template file

Examples

    # This calls shFormulaTemplate automatically
    formulaTemplate my-template-file.sh > /tmp/the-result

Returns true on success.


`shFormulaTemplate()`
---------------------

Run a POSIX shell script as a template.

Examples

    shFormulaTemplate my-template-file.sh > /tmp/the-result

Returns the status code of the shell script.


`wickAddConfigSection()`
------------------------

Writes a section to the end of a config file.  Idempotent - will not add another section with an identical name.  The opposite function is `wickRemoveConfigSection`.

* $1 - Config file.
* $2 - Name of the section (very important).
* $3 - Line comment delimeter, defaults to "#"
* stdin - Lines of configuration

This searches the file for a section with the same name and removes it. Next it creates a new section with the given name at the end of the file.

Returns 0 on success, 1 on argument validation errors.


`wickMakeDir()`
---------------

Creates a directory on the target machine.

*Only the last folder will have its ownership changed.*  See the examples for further information.

* $1            - The directory to create.
* --mode=MODE   - Optional, specify a mode for the directory.  Uses `chmod` syntax.
* --owner=OWNER - Optional, specify an owner for the directory.  Uses `chown` syntax.

The directory is created with `mkdir -p` so all parent directories would also be created if they do not exist.  The ownership and mode are only changed on the specified path, not all parents.

When specified, the mode and owner are always applied, even if the directory already existed.

Examples:

    # Creates /etc/consul.d (/etc already existed) with the mode 0755
    # and make consul the owner.
    wickMakeDir --mode=0755 --owner=consul:consul /etc/consul.d

    # Creates a folder named /a/b/c/d/ and changes the ownership of
    # /a/b/c/d/ to nobody:nogroup.  NOTE: All of the parent directories
    # will be created automatically if they didn't already exist and
    # they will be owned by root:root, NOT nobody:nogroup.
    wickMakeDir --owner nobody:nogroup /a/b/c/d/

Returns nothing.


`wickMakeFile()`
----------------

Copies a file from the formula to the target machine.  Files are stored in `files/` within the formula.  When `--template` is used, then files come from `templates/` instead.

It is good practice to have the destination either include the filename or else end in a slash (`/`) to avoid ambiguity.  See the examples for more information.

* $1                - The source file to use.  It must be in the `files/` directory for normal files or `templates/` when using a template engine.
* $2                - The destination directory or filename.  Will always create or overwrite this file.  The template engine suffix will be removed when using a template and specifying a destination directory.
* --formula=FORMULA - Optional; indicate that the source file comes from a different formula than the current one.
* --mode=MODE       - Optional; specify a mode for the file using `chmod` syntax.  Always sets the mode when specified, otherwise uses a default.
* --owner=OWNER -     Optional; specify an owner for the file using `chown` syntax.  Always sets the owner when specified, otherwises uses a default.
* --template        - Optional; indicate that the file should pass through a template engine before being saved on the target filesystem.

If the destination is a directory, the file will keep its original name and be copied to the directory.  When using templates, the template engine suffix will be stripped off.

If you want the destination directory to be created automatically, make sure you use a `/` at the end of the directory name.  It will be created with the installed file's owner and a default mode.  See the notes for the `wickMakeDir` function regarding ownership of directories.

Examples:

    # Writes /etc/rc.local from a template.
    wickMakeFile --mode=0755 --template rc.local.mo /etc/

    # Writes a root-only configuration file, renaming it as it is written.
    wickMakeFile --mode=0600 --owner=root:root secret.txt /root/secret.txt

    # Installs a file into a directory that does not exist.
    # The directory will be created and owned by "nobody", just like the file.
    # Note the / at the end of the destination
    wickMakeFile --mode=600 --owner=nobody:nobody config.ini /etc/a/b/c/d/

    # The same as above but the directory will NOT be created automatically
    # if it doesn't already exist.
    # If /etc/a/b/c/d exists as a directory then config.ini will be written
    # to that folder.  Otherwise, this will create the file /etc/a/b/c/d (not
    # /etc/a/b/c/d/config.ini), so be careful.
    wickMakeFile --mode=600 --owner=nobody:nobody config.ini /etc/a/b/c/d

    # Get a file from other-formula, no matter where it is located in the
    # parent hierarchy in relation to the current formula.
    wickMakeFile --formula=other-formula motd.txt /etc/motd

Returns true on success.


`wickMakeUser()`
----------------

Create or manage a user on the system.

* $1            - Username to create on the system
* --daemon      - Optional; flag to indicate reasonable settings should be assigned for a daemon account.  See the examples.
* --home=HOME   - Optional; set the home directory for the user.
* --move-home   - Optional; move a home directory for a user that already exists when this flag is used.
* --name=NAME   - Optional; full name for the account.
* --no-skel     - Optional; will prevent skeleton files from being copied when this flag is used.
* --shell=SHELL - Optional; set a shell that isn't the default for the user.
* --system      - Optional; uses a lower user ID when available when creating the user.

For consistency, the home directory is always created if it does not exist and the ownership of the home directory is always set to `USERNAME:USERNAME`.

Examples:

    # Create a normal user
    wickMakeUser fidian

    # Update that same user with a new shell
    wickMakeUser --shell=/bin/zsh

    # Create a system account that can't login.  It is used to
    # run a special server that's installed in /opt/myserver.
    wickMakeUser --home=/opt/myserver --name="MyServer"       --shell=/bin/false --no-skel --system myserver

    # The exact same command but it uses --daemon to specify
    # several options automatically.
    # --daemon enables --no-skel --system and disables --move-home
    wickMakeUser --daemon --home=/opt/myserver --name="MyServer" myserver

Returns true on success.


`wickPackage()`
---------------

Public: Install or remove packages on the target system.  This handles the OS-specific tools that are used to install or remove the packages.  If the package is named differently on various systems, it is up to the formula to address that, such as with the apache2 formula.

* $1               - Name of package to manage, typically required.
* --clean          - Cleans the cache of packages on the system.
* --exists         - When set, returns true if the package exists.  Does not install nor uninstall any package.
* --uninstall      - When set, this will uninstall the package instead.
* $YUM_ENABLE_REPO - Allows additional yum repositories.

Uses the `YUM_ENABLE_REPO` environment variable if you need to enable additional yum repositories, such as [Remi's Repository](../yum-remi/README.md), which can sometimes be a little dangerous.  This is only used with yum-based systems.

Examples

    # Install apache2 - note that this must match for your OS/distro
    wickPackage apache2

    # Uninstall httpd
    wickPackage --uninstall httpd

    # Clean the package cache
    wickPackage --clean

    # Enable Remi's repository for this one package so we install a
    # significantly newer version of Redis.
    YUM_ENABLE_REPO=remi wickPackage redis

Returns true on success for normal execution.  When `--exists` is used, this returns true if the specified package exists and is installed on the system.


`state`
-------

Intentionally append to state to flag errors


`wickPackageApt()`
------------------

Internal: Helper function to take action on apt-based systems.

* $1 - Desired package state.  One of "clean", "install", "uninstall" or "exists".
* $2 - Package name, required if state is not "clean".

Examples

    wickPackageApt install apache2

Return true on success.


`wickPackageYum()`
------------------

Internal: Helper function to take action on yum-based systems.

* $1               - Desired package state.  One of "clean", "install", "uninstall" or "exists".
* $2               - Package name, required if state is not "clean".
* $YUM_ENABLE_REPO - Enable additional repositories.

Examples

    wickPackageYum install httpd

Return true on success.


`wickRemoveConfigSection()`
---------------------------

Removes a named section from a config file.  Idempotent - will not modify a file that does not contain the named section.  This is the opposite of `wickAddConfigSection`.

* $1 - Config file.
* $2 - Name of the section (very important).

Returns nothing.


`wickService()`
---------------

Public: Control services.  Add services, enable and disable them at boot up. Start, stop, reload, restart services.  Helps with the creation of override files (for `chkconfig`).

* $1 - Action to perform, detailed below.
* $2 - Service name.

Examples

    # Creating a new service using the formula's files/consul.init
    # and copying it to the right spot.
    wickService add consul consul.init
    wickService enable consul
    wickService start consul

    # Make Apache require Consul before starting
    wickService make-override apache2
    sed -i 's/Required-Start:/Required-Start: consul/' /etc/chkconfig.d/apache2
    wickService override apache2

Returns nothing.


### `add [--force] [--*] SERVICE FORMULA_FILE`

Use `wickMakeFile` to copy the formula file to `/etc/init.d/` for the named service.  Does not enable nor start the service.  Does not add the service if the file already exists unless `--force` is also used.  You can also use any additional options that `wickMakeFile` supports.


### `disable SERVICE`

Disable the service from starting at boot.  Does not stop the service if it is already running.


### `enable SERVICE`

Enable the service at boot.  Does not start the service.


### `force-state SERVICE STATE`

Used by other scripts to force the service to be running or stopped.

* SERVICE - Name of service to manage.
* STATE - If empty, the service is stopped.  If not empty the service is restarted (ensuring it is running properly).


### `make-override [--force] SERVICE`

Creates `/etc/chkconfig.d/SERVICE` that is used by `chkconfig` to help determine order.  This override file can be modified to list additional dependencies to influence the boot order of scripts.  Make sure to call `wickService override` when you update an override file.  When using `--force`, this will overwrite any override file that may already exist.


### `override SERVICE`

Calls `chkconfig override` to apply any changes made to override files.


### `reload SERVICE`

Reloads the given service.


### `restart SERVICE`

Stops and starts the given service.


### `start SERVICE`

Starts the service.


### `stop SERVICE`

Stops the service.



`unparsed`
----------

Remove the action from the unparsed items


`wickServiceAdd()`
------------------

Internal: Add a service and inform chkconfig.

* $1 - Service name.
* $2 - Source file, passed to `wickMakeFile`.
* $@ - Other options, also passed to `wickMakeFile`.

Examples

    wickServiceAdd redis redis.conf.sh --template

Returns nothing.


`wickServiceConditionalRestart()`
---------------------------------

Internal: Restarts a service if it is running.

* $1 - Service name to possibly restart.

Examples

    wickServiceConditionalRestart tinyproxy

Returns nothing.


`wickServiceDisable()`
----------------------

Internal: Disable a service so it doesn't start on boot.

* $1 - Service name.

Examples

    wickServiceDisable consul

Returns nothing.


`wickServiceEnable()`
---------------------

Internal: Enables a service so it starts at boot.

* $1 - Service name.

Examples

    wickServiceEnable mongod

Returns nothing.


`wickServiceForceState()`
-------------------------

Internal: Restarts or stops a service

* $1 - Service name to stop.
* $2 - If empty, stops the service.  Otherwise it restarts the service.

Examples

    # Leaves the service stopped
    wickServiceForceState rsync

    # Leaves the service started (forcing a restart)
    wickServiceForceState rsync anything

    # Normal usage in other formulas that use --start
    wickGetOption start start "$@"
    wickServiceForceState the-service-name "$start"

Returns nothing.


`wickServiceIsRunning()`
------------------------

Internal: Determines if a service is running

* $1 - Service name to check.

Examples

    wickServiceIsRunning ssh

Returns nothing.


`wickServiceMakeOverride()`
---------------------------

Internal: Generates an override file for use with chkconfig so alternate dependencies may be used with a service without modifying the original service file.

* $1      - Service name.
* --force - Overwrite an override file if one exists.

Examples

    wickServiceMakeOverride mysql

Returns true on success, non-zero if the file exists and should not be clobbered.


`wickServiceOverride()`
-----------------------

Internal: Tell the system that an override file was updated.  This could shuffle the order of services in chkconfig.

* $1 - Service name that was updated.

Examples

    wickServiceMakeOverride ntp
    sed 's/Required:/Required: myServer/' /etc/chkconfig.d/ntp
    wickServiceOverride ntp

Returns nothing.


`wickServiceReload()`
---------------------

Internal: Reloads a service.

* $1 - Service name to reload.

Examples

    wickServiceReload nginx

Returns nothing.


`wickServiceRestart()`
----------------------

Internal: Restarts a service.

* $1 - Service name to restart.

Examples

    wickServiceRestart tinyproxy

Returns nothing.


`wickServiceStart()`
--------------------

Internal: Starts a service.

* $1 - Service name to start.

Examples

    wickServiceStart cron

Returns nothing.


`wickServiceStop()`
-------------------

Internal: Stops a service.

* $1 - Service name to stop.

Examples

    wickServiceStop rsync

Returns nothing.


