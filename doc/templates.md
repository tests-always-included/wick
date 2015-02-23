Templates - Wick Documentation
==============================

Templates
---------

The files contained within the `templates/` folder are extremely similar to the files that are copied verbatim to the target system, but they follow a naming convention and are processed by a template system.

Templates can be used by any function that installs files via `install-formula-file` (from [wick-base]).  Typically you can just pass `--template` to enable template processing.

    # This copies from files/filename.sh to /tmp/filename.sh
    install-formula-file filename.sh /tmp/

    # This uses a template in templates/filename.sh and the shell
    # template engine to generate /tmp/filename (no suffix)
    install-formula-file --template filename.sh /tmp/

When the destination is a directory, the template engine suffix is removed before the file is saved.

Template engines can be added by just including the right formulas.  As an example, you can add [mo] as a dependency and then mustache-style templates can be used.


### Mo (.mo)

Enable mustache-style templates by including the [mo] formula.

Example `depends` file:

    #!/bin/bash
    wick-formula mo

Example `run` script:

    #!/bin/bash
    set -e
    export NAME="Betty"
    export LIST=(one two three)
    install-formula-file --template name.mo /tmp

Example `templates/name.mo`:

    Your name is {{NAME}}
    {{LIST}}
    Item: {{.}}
    {{/LIST}

Example result in `/tmp/name`:

    Your name is Andrew
    Item: one
    Item: two
    Item: three


### Shell (.sh, .bash)

This is the only templating system that exists by default.  It is assumed that the files are shell scripts and the stdout from the shell script will be the contents of the file that will be saved.  If the shell script reports failure, the installation process is aborted.  (See [Bash concepts] for stdout and failure.)

The shell scripts can read from the environment or do anything that shell commands can normally do.

Example `run` script:

    #!/bin/bash
    set -e
    export NAME="Andrew"
    install-formula-file --template name.sh /tmp/

Example `templates/name.sh`:

    #!/bin/bash
    echo "Your name is $NAME"

Example result in `/tmp/name`:

    Your name is Andrew
