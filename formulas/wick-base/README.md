Wick-Base
=========

This formula does not perform any action.  It exists only to add useful functions and explorers to the Wick environment.

    wickFormula wick-base


Explorers
---------

### bash-version

Returns the version of Bash in use on the target system.

Example:

    wickExplorer RESULT wick-base bash-version
    echo "$RESULT"  # "4.3.30(1)-release"


### machine-type

Returns the type of machine we appear to be using.  Attempts to detect virtualization environments.  This explorer is a bit rudimentary and could be tricked.

Returned values:

* `amazon`: Running in Amazon AWS
* `unknown`: All other results

Example:

    wickExplorer RESULT wick-base machine-type
    if [[ "$RESULT" == "amazon" ]]; then
        echo "I am in Amazon AWS"
    fi


### os

Returns the best guess at the OS that's running.

Returned values:

* `apple`: Mac OS X
* `redhat`: RedHat or CentOS
* `ubuntu`: Ubuntu

Example:

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


Functions
---------

### formula-template

Process a formula's template file.  Automatically detects the template engine by the filename extension.  Writes results to stdout.  (See [Bash concepts] for stdout; [templates] about the template system.)

This is what `wickMakeFile` may use when processing templates.

    formula-template TEMPLATE

* `TEMPLATE`: Path to a template file.

Example:

    formula-template my-template-file.sh > /tmp/the-result


### wick-make-dir

Creates a directory on the target machine.

*Only the last folder will have its ownership changed.*  See the examples for further information.

    wick-make-dir [--mode=MODE] [--owner=OWNER] PATH

* `[--mode=MODE]`: Specify a mode for the directory using `chmod` syntax.  When specified, the mode is always set, even if the directory already existed.  Optional; does not change the mode unless the option is set.
* `[--owner=OWNER]`:  Designate an owner and possibly a group for the directory using `chown` syntax.  When specified, the ownership is always set even if the directory already existed.  Optional; does not change the ownership unless the option is set.
* `PATH`: The directory to create.  Uses `mkdir -p` so all parents directories would be created if they do not exist.  Ownership and mode is only changed on the specified path, not all parents.

Examples:

    # Creates /etc/consul.d (/etc already existed) with the mode 0755
    # and make consul the owner.
    wick-make-dir --mode=0755 --owner=consul:consul /etc/consul.d

    # Creates a folder named /a/b/c/d/ and changes the ownership of
    # /a/b/c/d/ to nobody:nogroup.  NOTE: All of the parent directories
    # will be created automatically if they didn't already exist and
    # they will be owned by root:root, NOT nobody:nogroup.
    wick-make-dir --owner nobody:nogroup /a/b/c/d/


### wickMakeFile

Copies a file from the formula to the target machine.  Files are stored in `files/` within the formula.  When `--template` is used, then files come from `templates/` instead.  (See [templates] for more about templates.)

*It is good practice to have the destination either include the filename or else end in a slash (`/`) to avoid ambiguity.  See the examples for more information.*

    wickMakeFile [--formula=FORMULA] [--mode=MODE] [--owner=OWNER]
        [--template] FILE DESTINATION

* `[--formula=FORMULA]`: Indicate that the source file comes from a different formula than the current one.
* `[--mode=MODE]`: Specify a mode for the file using `chmod` syntax.  Optional; does not change the mode unless the option is set.
* `[--owner=OWNER]`:  Designate an owner and possibly a group for the file using `chown` syntax.  Optional; does not change the ownership unless the option is set.
* `[--template]`: Switch to using a template as the source.  (See [templates].)
* `FILE`: The source file to use.  It must be in `files/` for normal files or `templates/` when using the template engine.
* `DESTINATION`: The file to create or overwrite.  This file is always written, even if it exists.  Does not check to make sure the directory exists first.

If the destination is a directory, the file will keep its original name and be copied to the directory.  When using templates, the template engine suffix will be stripped off.

If you want the destination directory to be created automatically, make sure you use a `/` at the end of the directory name.  It will be created with the installed file's owner and a default mode.  See the notes for the `wick-make-dir` function regarding ownership of directories.

Examples:

    # Writes /etc/rc.local from a template.
    wickMakeFile --mode=0755 --template rc.local.mo /etc/

    # Writes a root-only configuration file, renaming it as it is written.
    wickMakeFile --mode=0600 --owner=root:root secret.txt /root/super-secret-key.txt

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


### wick-make-user

Create or manage a user on the system.

    wick-make-user [--daemon] [--home=DIR] [--move-home] [--name=NAME] \
        [--no-skel] [--shell=SHELL] [--system] USERNAME

* `--daemon`: Set reasonable settings for daemon processes.  See the examples.
* `--home=DIR`: Sets the home directory for the user.
* `--move-home`: If the user already existed on the system and the home directory is changed, this flag will also move all of the files.
* `--name=NAME`: Sets the full name field in the password entry.
* `--no-skel`: Do not copy the skeleton files into the home directory.
* `--shell=SHELL`: Sets the login shell for the new or updated user.
* `--system`: Uses a lower UID when available to create the user.
* `USERNAME`: Username to create on the system.

For consistency, the home directory is always created if it does not exist and the ownership of the home directory is always set to `USERNAME:USERNAME`.

Examples:

    # Create a normal user
    wick-make-user fidian

    # Update that same user with a new shell
    wick-make-user --shell=/bin/zsh

    # Create a system account that can't login.  It is used to
    # run a special server that's installed in /opt/myserver.
    wick-make-user --home=/opt/myserver --name="MyServer" \
        --shell=/bin/false --no-skel --system myserver

    # The exact same command but it uses --daemon to specify
    # several options automatically.
    # --daemon enables --no-skel --system and disables --move-home
    wick-make-user --daemon --home=/opt/myserver --name="MyServer" myserver


### wick-hash

Return a hash for a file.  The type of hash returned is based on what's available on the system.  You can use this to see if files change their contents.

    wick-hash DESTINATION FILENAME

* `DESTINATION`: Name of environment variable that will get the resulting hash value
* `FILENAME`: File to hash.


### wickPackage

Install or remove packages on the target system.  This handles the OS-specific tools that are used to install or remove the packages.  If the package is named differently on various systems, it is up to the formula to address that (see the [apache2] formula).

    wickPackage [--uninstall] PACKAGE [...]

* `[--uninstall]`: Remove the packages instead of installing it.
* `PACKAGE`: Name of package to install

Uses the `YUM_ENABLE_REPO` environment variable if you need to enable additional yum repositories, such as [Remi's Repository](../yum-remi/README.md), which can sometimes be a little dangerous.  This is only used with yum-based systems.

Examples:

    wickPackage --uninstall apache
    wickPackage apache2

    # Enable Remi's repository for this one package so we install a
    # significantly newer version of Redis.
    YUM_ENABLE_REPO=remi wickPackage redis


### wickService

Control services.  Add services, enable and disable them at boot up.  Start, stop, reload, restart services.  Helps with the creation of override files (for `chkconfig`).

    wickService COMMAND SERVICE

* `COMMAND`: Action to perform.
* `SERVICE`: Service name.

Actions:

* `add [--force] [--*] SERVICE FORMULA_FILE` - Use `wickMakeFile` to copy the formula file to `/etc/init.d/` for the named service.  Does not enable nor start the service.  Does not add the service if the file already exists unless `--force` is also used.  You can also use any additional options that `wickMakeFile` supports.
* `disable SERVICE` - Disable the service from starting at boot.  Does not stop the service if it is already running.
* `enable SERVICE` - Enable the service at boot.  Does not start the service.
* `make-override [--force] SERVICE` - Creates `/etc/chkconfig.d/SERVICE` that is used by `chkconfig` to help determine order.  This override file can be modified to list additional dependencies to influence the boot order of scripts.  Make sure to call `wickService override` when you update an override file.  When using `--force`, this will overwrite any override file that may already exist.
* `override SERVICE` - Calls `chkconfig override` to apply any changes made to override files.
* `reload SERVICE` - Reloads the given service.
* `restart SERVICE` - Stops and starts the given service.
* `start SERVICE` - Starts the service.
* `stop SERVICE` - Stops the service.

Example:

    # Creating a new service using the formula's files/consul.init
    # and copying it to the right spot.
    wickService add consul consul.init
    wickService enable consul
    wickService start consul

    # Make Apache require Consul before starting
    wickService make-override apache2
    sed -i 's/Required-Start:/Required-Start: consul/' /etc/chkconfig.d/apache2
    wickService override apache2


### wick-set-config-line

Adds or updates a line in a config file.  This is a very basic tool that ensures a line exists in a file, not that it is in any particular order.

    wick-set-config-line FILE LINE [KEY]

* `FILE`: File to update.
* `LINE`: Line to add.  This line will be placed at the end.
* `KEY`: The "key" that we are setting.  Optional and defaults to a portion of `LINE`.

The line is not repeatedly added to the config file.  First, we attempt to get the "key" for the line, either automatically or use a value that is passed in.  Most config files use a key value of some sort and this script usually can detect them - more on this later.  Next, we remove any lines with the same key from the file and finally we append the line you want onto the file.

The key can be automatically detected.  It is anything in LINE that is to the left of a space, colon, or equals.  If you are having difficulty understanding what is used as the key, check out the examples.  I have listed what `wick-set-config-line` uses as the key.

This is not suitable for updating shell scripts and other similar-looking files.  For instance, if you tried to modify `/etc/rc.local` and add two lines (`bash /script1` and `bash /script2`) then only one would ever exist in the file because "bash" would be considered the key.

Example:

    # This wipes out any previous settings for 127.0.0.1 and replaces them.
    # Key is "127.0.0.1"
    wick-set-config-line /etc/hosts "127.0.0.1 localhost some-funky-name"

    # Set the bind IP for mongo
    # Detects the current IP using `wick-get-iface-ip`
    # Key is "bind_ip"
    wick-set-config-line /etc/mongod.conf "bind_ip=$(wick-get-iface-ip)"

    # Update cloud-init
    # Key is "preserve_hostname"
    wick-set-config-line /etc/cloud/cloud.cfg "preserve_hostname: true"

    # Update DHCP settings
    # Key is "prepend nameservers" because we specify it as a third
    # parameter.
    wick-set-config-line /etc/dhcp/dhclient.conf \
        "prepend nameservers 127.0.0.1" "prepend nameservers"


[Apache]: ../apache2/README.md
[Bash concepts]: ../../doc/bash-concepts.md
[Formulas]: ../../formulas/README.md
[templates]: ../../doc/templates.md
