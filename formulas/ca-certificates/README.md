CA-Certificates
===============

Adds a function that will install a CA certificate in the system's certificate store.

Examples

    # Add this as a dependency
    wick-formula ca-certificates

    # Adds files/my-cert.cer from the formula into the system
    caCertificatesAdd my-cert.cer

Returns nothing.


`caCertificatesAdd()`
---------------------

Adds a CA certificate to the system certificate store.  The cert is renamed to match the fingerprint.

DER style certificates are changed into PEM certificates.

Examples

    # Uses a file from the formula, like wickMakeFile.
    caCertificatesAdd newfile.crt

    # Uses a file from stdin
    curl http://example.com/cert.pem | caCertificatesAdd

Many thanks to the wonderful page that listed the commands: http://kb.kerio.com/product/kerio-connect/server-configuration/ssl-certificates/adding-trusted-root-certificates-to-the-server-1605.html

Returns true on success.  If unable to figure out how to add the cert to the system's list, this returns 1.  If the certificate is invalid or is unable to be parsed by openssl, returns 2.


