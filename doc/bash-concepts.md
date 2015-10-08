Bash Concepts
=============

Bash is aligned strongly with the Unix philosophy.  As such, this can cause moments of confusion while trying to understand why and how things work the way that they do.  The goal of this document is to demystify various topics and let the rest of the documentation link here instead of explaining it poorly multiple times.

The examples here are captured from a terminal.  Lines that start with `~$` are the prompt where you type commands.  The part before `$` bit indicates the current working directory, and `~` means my home directory.  The stuff after `$` are the commands that I type.  Other lines are the output from the command.  In this example I make a directory, go into that directory and then perform a file listing.  There's no files in the new directory, so the file listing does not produce any output.

    ~$ mkdir test
    ~$ cd test
    ~/test$ ls
    ~/test$ cd ..
    ~$ rmdir test
    ~$

Comments to explain commands are added sometimes to help clarify what's going on.  They start with a `#` symbol and continue to the end of the line.  You don't need to type them in, but if you do you won't mess anything up.

    ~$ # This is a comment
    ~$ # Comments do not affect the shell
    ~$


Success and Failure Return Codes
--------------------------------

Programs can report success by returning a status code of 0.  Anything else is considered a failure.  In the way of the Unix, there is only one success but many reasons why something can fail.

When shell scripts do not use an `exit` keyword, the status code of the shell script will be equal to the last executed command's status code.  You can see the status code by using `$?`.  Here is an example:

    ~$ # Create a file, list it, then show the success status code
    ~$ touch somefile.txt
    ~$ ls somefile.txt
    somefile.txt
    ~$ echo $?
    0
    ~$ # Remove the file, list it, show the error status code
    ~$ rm somefile.txt
    ~$ ls somefile.txt
    ls: cannot access somefile.txt: No such file or directory
    ~$ echo $?
    2
    ~$

Shell scripts can pick their return code and abruptly stop the program at any time using the `exit` keyword.  Here is a simple shell script that exits with a number that's equal to the number of arguments passed to it.

    ~$ cat > simple-script <<'EOF'
    > #!/usr/bin/env bash
    > exit $#
    > EOF
    ~$ chmod 755 simple-script
    ~$ ./simple-script
    ~$ echo $?
    0
    ~$ ./simple-script one two three
    3
    ~$


Stdout and Stderr
-----------------

Every process that's running can write output to "stdout" and "stderr".  Typically, the non-error output goes to stdout and error messages go to stderr.  Stdout is captured using `>` and stderr is captured using `2>`.  Take a look at this example.

    ~$ cat > stdout-stderr <<'EOF'
    > #!/usr/bin/env bash
    > ls $@ > stdout 2> stderr
    > echo "stdout:"
    > cat stdout
    > echo "stderr:"
    > cat stderr
    > EOF
    ~$ chmod 755 stdout-stderr
    ~$ touch somefile.txt
    ~$ ./stdout-stderr somefile.txt
    stdout:
    somefile.txt
    stderr:
    ~$ rm somefile.txt
    ~$ ./stdout-stderr somefile.txt
    stdout:
    stderr:
    ls: cannot access somefile.txt: No such file or directory
    ~$

To write to stdout in a shell script is trivial.

    echo "This goes to stdout"

Writing content to stderr is slightly more difficult but you can do it!

    echo "This goes to stderr" >&2


Sourcing Files
--------------

Here is sourcing a file in two different ways:

    ~$ # Method 1
    ~$ source some-other-file
    ~$ # Method 2
    ~$ . some-other-file

What does it do?  It pretends that you typed in the commands in that other file in this shell.  Let's use a better example.

    ~$ # Create a file with a function in it
    ~$ cat > testing-function <<'EOF'
    > #!/usr/bin/env bash
    > testMe() {
    > echo "This is the function"
    > }
    > echo "testing-function was sourced or executed"
    > EOF
    ~$ chmod 755 testing-function
    ~$

When you run the test script it will not create the function in the current environment.

    ~$ ./testing-function
    testing-function was sourced or executed
    ~$ testMe
    testMe: command not found
    ~$

When you source the test script, the function is added to your environment and you can use it.

    ~$ . testing-function
    testing-function was sourced or executed
    ~$ testMe
    This is the function
    ~$
