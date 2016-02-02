Java-Util
=========

Adds useful functions into the Wick environment that are related to Java.

Examples

    wickFormula java-util


`javaUtilGetHome()`
-------------------

Gets the JAVA_HOME folder directly from Java.  Note:  This is for the Java environment that is associated with `java`.  It could be a JRE or JDK.

* $1 - Destination variable name for JAVA_HOME.

Examples

    javaUtilGetHome VARNAME
    echo "$VARNAME" # Could write out /usr/lib/jvm/java-8-openjdk-amd64/jre

Returns 0 on success, non-zero if there is any issue getting the home folder.


