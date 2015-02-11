Wick - Configuration and Provisioning Tool
==========================================

Wick is another alternative IT automation software package.  It provisions machines, configures software, sets up users and tasks, reloads services and does the rest of the mundane things that you would expect.  It's written in bash and requires bash and coreutils.  You probably have it installed, as even routers and minimal installations of cygwin on Windows will have enough.  Consider it a simpler version of [Chef], [Ansible] or [Puppet], more along the lines of a [cdist] or [bash-booster].

The idea is that you would write installation scripts for individual tasks.  We call them formulas (like recipes, playbooks, types from other systems).  Then you would use Wick to run these scripts.  The whole task would be automated and repeatable.


Why another tool?
-----------------

I'm really glad that you asked this, as it seems that yet another tool on the scene wouldn't provide enough of a variance to warrant the time and effort.

The goals of this project, in order:

### No dependencies.

Nearly every system has Bash.  Not every system has Ruby, Python, Perl, or even a C compiler.  By reducing the requirements, we lower the barrier to entry.


### Simplicity.

Every administrator must know some shell commands.  Not every administrator wants to know the other languages and markup styles.  Most of the time the other tools boil down to shell scripts anyway, so let's pare things down to 1 language.

You don't need to install a server in order to start using this tool either.  Just copy the files to the destination and run it.


Usage
=====

... To be determined.


[Ansible]: http://www.ansible.com/
[bash-booster]: http://www.bashbooster.net/
[cdist]: http://www.nico.schottelius.org/software/cdist/
[Chef]: https://www.chef.io/
[Puppet]: http://puppetlabs.com/
