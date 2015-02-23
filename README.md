Wick - IT Automation
==========================================

Wick is a Bash IT automation tool, which means it can provision machines, configures software, sets up users and tasks, reloads and does the rest of the mundane things that you would expect.  It's written in Bash and has extremely minimal requirements (Bash 3.x and coreutils).  You probably have enough already installed; even routers and minimal installations of [Cygwin] on Windows will have enough.

The idea is that you would write installation scripts for individual tasks.  We call them formulas (like recipes, playbooks and types from other systems).  Then you would use Wick to run these scripts.  The whole task would be automated and repeatable.

This relies heavily on Bash concepts.  For help with understanding them, there is documentation covering the key [Bash concepts].


How do I get started?
---------------------

A little terminology will go a long way.

* [Roles] are lists of formulas to be executed.  An example role might be "apache-web-server" or "mongodb-replica-set-member".  Roles do not take any configuration parameters.

* [Formulas] are installation scripts or tasks.  They can come with all of the following:
    * Dependencies, which is just a list of other formulas that are required
    * Explorers that will inspect the target system and report information
    * Files that could be installed on the target system
    * Functions, which are added to the environment so other formulas can leverage these tools
    * Run script to perform the installation action
    * Templates that can be translated and then installed on the target system

* [Libraries] are functions that are loaded into the environment.  They can be installed in the target system and used in installed shell scripts using [wick-infect].

* [Binaries] are commands that can be called from Wick directly.  They can be expanded to allow for starting virtual machines, performing mass automation on a group of server and other tasks.

* [Parents] define some base functionality that you can override or leverage.  There can be multiple levels of ancestry, allowing you to group your formulas from extremely generic to quite individual and specific.

Additional reading:

* [Bash concepts] that are often used in this documentation.
* Formula [execution order] explained, leaving no mysteries regarding when specific things happen.
* [Tests] can help ensure that your formulas run on a variety of systems.


What does it look like?
-----------------------

If you look at the file structure of this repository, you will see a few directories.  Let's just focus on `formulas/`.  Inside is typically a `run` script, possibly a `depends` file that lists dependencies, `files/` and `templates/` for files that get used on the target machine, `explorers/` to determine settings on the target machine, and possibly other tidbits.

To give you a good understanding of the function of formulas, here are a couple examples.


### Install `git`

This one is pretty easy.  You simply need to install a package.  The formula's `run` script would look like this:

    #!/bin/bash
    set -e

    wick-package git

And you're done.

`set -e` turns on error catching, so that if there was any sort of error then the script reports it immediately instead of continuing with the script (*highly recommended*).

`wick-package` is a function that the `wick-base` formula exposes.  It provides an OS-agnostic way to install packages.  Just list the name of the package afterwards and you're set.


### Apache Virtual Host

You can create a virtual host with three files in your formula.  First, the virtual host config would go in `files/` with a suitable name, such as `files/vhost.conf`.  Next, we have a dependency on Apache and need it installed and running before our formula starts to execute.

    #!/bin/bash

    wick-formula apache2

The bulk of the work is in the formula's `run` script.

    #!/bin/bash
    set -e

    apache2-add-vhost vhost.conf

There.  Now the vhost will be added to Apache, the server will be reloaded and everything will be ready.  This formula is complete.


Why another tool?
-----------------

There are quite a few other tools out there that also perform the same tasks.  Before taking on this endeavor and writing Wick, it is good to know the strengths and weaknesses of other systems.  [Chef], [Ansible] and [Puppet] are great alternatives, while [cdist] and [bash-booster] are also Bash-centric.

First, it was important to have as few dependencies as possible.  I don't want to install package after package on the target system just so I can install more things.  It seemed odd that I would require Ruby, Python, Perl or a C compiler on a machine just to update some config files.  In an ideal world, nothing would be installed at all and the whole thing would happen over SSH.  By reducing the number of requirements, we also lower the barrier to entry and hopefully make things easier.

Secondly, shell scripts are nearly universal.  Every administrator must know some shell commands.  Not every administrator wants to know additional languages to use the alternate tools.  Most of the time the other tools boil down to shell scripts anyway, so let's pare things down to 1 language.  Sure, there are sections here using some of the more advanced features of Bash, but the formulas should be extremely small, simple to write and easy to understand.

Lastly, a lot of "fluff" or complexity has been eliminated.  For instance, you do not need to set up a server to allow for a client/server model.  I don't need to have a central repository of scripts.  There's no need for a database to track all of the instances.  Wick will just get a machine up and running quickly.


Usage
-----

Well, assuming you have created some formulas and at least one role, you are able to run `wick`.

    wick provision your-role-name [role2 [...]]

Now all you need to know is how to make [roles] and [formulas].  While you are at it, writing [tests] can also help prove that the installers work in a variety of environments.


[Ansible]: http://www.ansible.com/
[bash-booster]: http://www.bashbooster.net/
[Bash Concepts]: doc/bash-concepts.md
[Binaries]: bin/README.md
[cdist]: http://www.nico.schottelius.org/software/cdist/
[Chef]: https://www.chef.io/
[Cygwin]: https://www.cygwin.com/
[Execution Order]: doc/execution-order.md
[Libraries]: lib/README.md
[Formulas]: formulas/README.md
[Parents]: doc/parents.md
[Puppet]: http://puppetlabs.com/
[Roles]: roles/README.md
[Tests]: tests/README.md
[wick-infect]: formulas/wick-infect/README.md
