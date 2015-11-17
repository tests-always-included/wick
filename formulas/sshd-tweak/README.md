SSHD Tweak
==========

Alters the SSH server's settings.

* --agent-forwarding[=no] - Allow/deny agent forwarding.
* --faster-login          - Enables faster login (disable DNS and GSSAPI). Same as using `--use-dns=no --gssapi-auth=no`
* --gssapi-auth[=no]      - Enable/disable GSSAPI authentication.
* --password-auth[=no]    - Allow/deny password authentication mechanisms.
* --use-dns[=no]          - Enable/disable DNS

For `=no`, that means it is optional.  The default is to enable the option.  You turn off the option by using "no" and turn on the option by not specifying a value.  See the examples for more information.

Each of these options will toggle one setting in the config file, unless otherwise noted.

If there were any changes to the file, sshd is reloaded.

Examples

    # Faster logins
    wickFormula sshd-tweak --faster-login

    # Same as above
    wickFormula sshd-tweak --use-dns=no --gssapi-auth=no

    # Enable agent forwarding and disable passwords
    wickFormula sshd-tweak --agent-forwarding --password-auth=no

Returns nothing.


`sshdTweakSetting()`
--------------------

Internal: Changes a single setting for sshd based on the value from an option passed to the formula.

* $1       - Setting to change
* $2       - Name of the option
* $options - All options passed to the formula.
* $config  - Config file to update.

Scans through `$options` for `--$2` or `--$2=no`.  If the value is "no", disables the option (adds "$1 no" to the config file).  When the value is "true" (because that's how wickGetOption works) it enables the setting in the config file.

Returns nothing.


