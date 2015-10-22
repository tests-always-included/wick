Redis
=====

Installs redis onto the box.

* --password=PASS - Sets a password for this redis installation

There are many other settings you can tweak for better performance beyond what this formula set.  Each one should be tested to determine if they are applicable to the situation. http://shokunin.co/blog/2014/11/11/operational_redis.html

Examples

    wickFormula redis

    wickFormula redis --password="A very long password goes here"

Returns nothing.


