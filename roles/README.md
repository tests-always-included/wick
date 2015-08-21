Roles - Wick
============

A role is nothing more than a list of formulas, nearly identical to the `depends` file that [formulas] use to list their dependencies.  Roles can use the explorers that [formulas] provide.  Roles are able to reference other roles in the chain of [parents], though that may cause confusion when referring to a role that's not at the same level as the role being executed.


Sample Role
-----------

Here is a fictional role that could stand up a web server running a copy of a PHP application.  There's comments added to explain what each formula should be doing.

    #!/bin/bash
    wick-formula wick-base                      # Useful functions and explorers
    wick-formula hostname app-demo.example.com  # Set the hostname and domain
    wick-formula apache2                        # Install Apache2
    wick-formula php5                           # Install PHP5

    case "$ENVIRONMENT" in
        prod)
            # Production code, production data
            wick-formula app-demo --env=prod
            wick-formula app-data --env=prod
            ;;

        test)
            # Production code, testing data
            wick-formula app-demo --env=prod
            wick-formula app-data --env=test
            ;;

        *)
            # Testing code, testing data
            wick-formula app-demo --env=test
            wick-formula app-data --env=test
            ;;
    esac

There you have it.  This role will trigger the execution of 6 other functions, passing appropriate parameters as needed.

Just like the `run` script of [formulas], roles can take parameters from the command line.  If that does not work you can use an explorer or use environment variables.  This next example does all three.  One can also load another role using the `WICK_ROLE_DIR` variable.

    #!/bin/bash

    # Parse arguments
    # This gets set to a non-empty string if --extra is passed
    wick-get-option EXTRA extra "$@"

    # Load another role to do some basic setup
    # This uses `wick-formula` to do a lot of basic stuff to the target machine
    wick-load-role "our-base-formulas"

    # Use the command-line argument
    if [[ ! -z "$EXTRA" ]]; then
        wick-load-role "our-extra-formulas"
    fi

    # Check the output of an explorer
    wick-explorer ARCH wick-base arch

    case "$ARCH" in
        amd64)
            wick-package ia32-libs
            wick-formula special-package --64bit
            ;;

        ia32)
            wick-formula special-package --32bit
            ;;

        *)
            wick-error "Unknown architecture: $ARCH"
            exit 1
    esac

    # Finally check an environment variable
    if [[ ! -z "$NEEDS_APACHE" ]]; then
        wick-formula apache2
    fi


[execution order]: ../doc/execution-order.md
[Formulas]: ../formulas/README.md
[parents]: ../doc/parents.md
