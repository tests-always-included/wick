MySQL Server
============

Installs the MySQL relational database server.

Sets a random password for the root account and adds ~root/.my.cnf so you can still use the root account when you use `sudo mysql`.

* --start - Ensure the service is started at the end of the formula.  When omitted, this will force the server to be stopped instead.

Examples

    wickFormula mysql-server

Returns nothing.


`mysqlServerCreateDb()`
-----------------------

Create a database.

* $1 - Name of the database.

Examples

    mysqlServerCreateDb potato

Returns nothing.


`mysqlServerCreateUser()`
-------------------------

Creates a user.

* $1 - Username and hostname.  If no host is specified,localhost is assumed.
* $2 - Password for the user.

Examples

    # Create a local user
    mysqlServerCreateUser bob 'Robert!'

    # Create a user that can access the server from any remote machine
    mysqlServerCreateUser sally@% Fields

Returns nothing.


`mysqlServerExecuteSql()`
-------------------------

Run SQL against the MySQL server.

* $1    - Database to execute against.
* stdin - SQL to execute.

If the server is not started, this will automatically start the service, run the SQL and stop the service.

Examples

    echo "FLUSH PRIVILEGES" | mysqlServerExecuteSql mysql

    wickMakeFile --template --formula=mysql-server create-db.mo |       mysqlServerExecuteSql mysql

Returns nothing.


`mysqlServerGrant()`
--------------------

Grants privileges to a user.

* $1    - User that receives the permissions.  If a host is not specified, defaults to localhost.
* $2    - Database.  Can be "db" or "db.table" or "db.*".  If no tables are specified, defaults to `*`.
* --all - Same as --grant="ALL PRIVILEGES"

Examples

    # Read-only access to users database for tim@localhost
    mysqlServerGrant tim users

    # Full access to users database for admin@localhost
    mysqlServerGrant addmin --all users

    # Same as above
    mysqlServerGrant --grant="ALL PRIVILEGES" admin@localhost users.*

Returns nothing.


`mysqlServerSplitUsername()`
----------------------------

Internal: Takes the username and optional hostname.  Splits them out into separate fields, defaulting the hostname to "localhost" when not specified.

* $1 - Target for the array of data
* $2 - Username and hostname (user@host).

Examples

    mysqlServerSplitUsername destInfo user
    # destInfo=([0]="user" [1]="localhost")

    mysqlServerSplitUsername destInfo user@%
    # destInfo=([0]="user" [1]="%")

Returns the parsed information as an arry to $1.


