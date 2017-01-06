SELinux
=======

Configures SELinux into a given state.

* $1 - Desired state.

Allowed states:

* `disable`: Completely disables SELinux so that no rules will be enforced.

Reconfigures [SELinux](https://en.wikipedia.org/wiki/Security-Enhanced_Linux) so that it is disabled.

Examples

    wickFormula selinux disable

Returns nothing.


`selinuxIsEnabled()`
--------------------

Returns success (0) when SELinux is installed and enabled.

Examples

    # Convoluted, but necessary because of strict mode and newer Bash.
    # See doc/contexts-that-disable-exit-on-error.md
    local result

    wickStrictRun result selinuxIsEnabled

    if [[ "$result" -eq 0 ]]; then
        wickWarn "This does not work well with SELinux enabled"
    fi

Returns true if it is enabled and it is being enforced.


