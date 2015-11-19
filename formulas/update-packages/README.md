Update Packages
===============

Updates all packages on the system except kernel updates.

For RedHat and CentOS this will skip kernel updates because that may unintentionally break the guest additions when the machine is under VirtualBox or another virtualization system.

When guest additions are installed and the kernel is updated, it appears that one must also reboot and then recompile the guest additions against the updated headers in order for things to work.  To avoid that problem we just skip the kernel packages.

Examples

    wickFormula update-packages

Returns nothing.


