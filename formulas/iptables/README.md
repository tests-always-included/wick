IPTables
========

Installs `iptables` if it is not already installed.

Examples

      wickFormula iptables

Returns nothing.


`iptablesSave()`
----------------

External: Saves iptables rules so that on reboot the rules will persist.

Examples

      # Add a rule and save it.
      iptables -I INPUT -j ACCEPT
      iptablesSave

Returns a non zero value if it cannot figure out how to save.


