Redis
=====

Installs redis onto the box.

* --password=PASS           - Sets a password for this redis installation
* --start                   - Starts the service.  If not passed, the service will not be running when the formula ends.
* --master-password=PASS    - Sets "masterauth" in the configuration.  This should be set to the value of the masters password if you are replicating and the master requires auth.

There are many other settings you can tweak for better performance beyond what this formula set.  Each one should be tested to determine if they are applicable to the situation. http://shokunin.co/blog/2014/11/11/operational_redis.html

Examples

    wickFormula redis --start

    wickFormula redis --password="A very long password goes here"

    wickFormula redis --password="My password" --master-password="Master password for replication"

Returns nothing.


`redisSetConfigLine()`
----------------------



Public: Sets a value in the redis.conf file.  If the config already has the configKey provided it will overwrite it.  If the configValue is empty, the line which starts with the configKey will be removed.

* $1 - The name of the config value you would like to set.
* $2 - The value you would like to set the config value to. If the value is empty it will remove that config setting.

Examples

    redisSetConfigLine "requiresauth" "my password"

    redisSetConfigLine "unsetthisvalue" ""

Returns nothing.


