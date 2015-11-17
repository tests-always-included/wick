Tomcat 7
========

Installs Tomcat 7, which depends on Java 1.7 or Java 1.8.

* --java-1.8 - Depend on Java 1.8 instead of 1.7.
* --start    - Starts the service.  If not passed, the service will not be running when the formula ends.

Examples

    # Use Java 1.7 and start it
    wickFormula tomcat-7 --start

    # Use Java 1.8
    wickFormula tomcat-8 --java-1.8

Returns nothing.


