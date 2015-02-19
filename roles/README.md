Roles - Wick
============

A role is nothing more than a list of formulas, nearly identical to the `depends` file that [formulas] use to list their dependencies.  Roles can use the explorers that [formulas] provide.  Roles are able to reference other roles in the chain of [parents], though that may cause confusion when referring to a role that's not at the same level as the role being executed.


Sample Role
-----------

Here is a fictional role that could stand up a web server running a copy of a PHP application.  There's comments added to explain what each formula should be doing.

    #!/bin/bash
    set -e
    wick-formula wick-base                      # Useful functions and explorers
    wick-formula hostname app-demo.example.com  # Set the hostname and domain
    wick-formula apache2                        # Install Apache2
    wick-formula php5                           # Install PHP5
    
    case "$ENVIRONMENT" in
        prod)
            # Production code, production data
            wick-formula app-demo --env=prod
            wick-formula app-data --env=test
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

Unlike the `run` script of [formulas], roles are unable to take parameters from the command line.  If you need to pass information to them, it is suggested that you use an explorer or possibly an environment variable.  This next example does both.  One can also load another role using the `WICK_ROLE_DIR` variable.

    #!/bin/bash

    # This uses `wick-formula` to do a lot of basic stuff to the target machine    
    . "$WICK_ROLE_DIR/our-base-formulas"

    wick-explorer OS wick-base os
    
    if [[ ! -z "$NEEDS_APACHE" ]]; then
        wick-formula apache2
    fi
    
    if [[ "$OS" == "unknown" ]]; then
        wick-formula install-a-known-flavor-of-linux
    fi


[execution order]: ../doc/execution-order.md
[Formulas]: ../formulas/README.md
[parents]: ../doc/parents.md