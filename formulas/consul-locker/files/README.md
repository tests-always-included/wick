Consul-Locker
=============

This is a Bash shell script that will leverage [Consul]'s sessions and key-value store to ensure only one process will run in your data center at a time.


Requirements
------------

1.  You must have this program somewhere on your system.  It makes the most sense in `/usr/local/bin` or in a folder listed in your `PATH`.  It can be called directly.
2.  [Consul] is running on the same machine; this utility uses `localhost:8500` for communication.
3.  Bash 3 or better.
4.  Curl is installed and in the `PATH`.


How to Run
----------

Consul-Locker takes at least two parameters.

    consul-locker [options] serviceName commandToRun [commandArguments]

* `--help` or `-h` - Show the help message.
* `--no-wait` - Do not wait for a lock, exit immediately if it is not obtained.
* `serviceName` - Name of service to lock in [Consul].  Should be a single string.  It's used in a URL so properly URL-encode any special characters or just omit those.
* `commandToRun` - The executable you want to run.
* `commandArguments` - Any extra arguments or options to pass to the command.

Examples:

    # This runs our 10 second wait program
    ./consul-locker test examples/10-second-wait

    # Configure Mongo to either be a standalone master or join a cluster.
    ./consul-locker mongodb examples/mongodb-replicaset bootstrap

    # Run our 10 second wait program
    ./consul-locker test examples/10-second-wait

    # And in a second shell, this will exit 1 immediately
    ./consul-locker --no-wait test examples/10-second-wait

Don't forget to check out the scripts in the [examples folder].


Why This Is Good
----------------

### Scenario 1 - MongoDB

Let's say you are totally on board with this cloud-centric datacenter idea.  You've gone and converted your old software to use MongoDB and you ensure that at least three of these are running at any time in order to keep your cluster alive.  In fact, you use Amazon's AWS and CloudFormation to create your Auto-Scaling Groups.  Your boss thinks you did a great job and this should be deployed to the rest of the company.  People want the environments created for them frequently.  You want this whole bit automated.  Then you hit a problem.

Your scripts to automatically cluster MongoDB don't work when three of the machines spin up simultaneously.  They all detect that there is no master and will bootstrap themselves to be masters.  They never reset the clustering once they know about each other.  Bootstrapping now becomes a manual process again.

The solution is to alter the `init.d` scripts or have another service on boot that will run Consul-Locker and possibly the included bootstrap script for MongoDB.  That ensures only one tries to become master at a time and the others don't try to cluster with a node that isn't fully ready.  Errors disappear.


### Scenario 2 - Report Processing

There are several servers that collect data and send it to a central data store.  Every hour you need to aggregate the results and pass them to another location for reports.  This aggregation process only needs to run on one machine and it doesn't matter if multiple jobs run sequentially.  The only bad time is when two run simultaneously.  When you are launching identical copies of machines into the cloud, they all think they're the one to do the report aggregation and their clocks are synchronized so they'll all kick off the job at 3:00 AM sharp.

There's several techniques you can employ to help limit the problem.  You could check for CPU usage and not run reports on loaded machines.  The report jobs could wait a random amount of time between runs in order to stagger the processing.  You could try to configure machines independently so they take turns or report processing is enabled/disabled by some configuration.

A cleaner solution is to have all of them run the reports.  Again, this relies on the fact that we can safely run the aggregation job over and over, just not at the same time.  Have Consul-Locker call your reporting script and it will make sure only one copy is running at a time.


How Consul-Locker Works
-----------------------

Here's a step-by-step breakdown of the tasks it performs:

* Double check the commands are present and settings are appropriate.

* Open a session by using the [Consul Agent HTTP API].  This session will time out after 15 seconds.

* Obtain a lock on a key named `consul-locker-$serviceName` where `$serviceName` is passed in from the command line.  This will loop and try forever and also continually renew the session every 10 seconds.

* Once a lock is obtained, this runs you command that was provided on the command line.  Your script can execute for as long as needed and the session will still automatically renew every 10 seconds.  When your program is done, the return code is preserved.

* Clean up the session and the lock.  They would get deleted automatically anyway, but this is much more polite.

* Return the status code from your program.

Care was taken to make this tool as generic as possible while trying to prevent any constraints on the thing being executed.  If things crash or the machine becomes unresponsive, the lock will be released in 15 seconds and the other machines in the data center will continue to work.


Possible Problems
-----------------

* Your program may enter an infinite loop when you prefer it to terminate.  A timer could be implemented in this tool, but perhaps a better watchdog process could be leveraged.

* The machine becomes so overloaded that it can not renew the session fast enough.  This could cause spurious results or unintended consequences.  Hitting the local [Consul Agent HTTP API] is pretty lightweight and there isn't much this tool can do to mitigate this problem besides increasing the session TTL.


Development and Testing
-----------------------

Consul-Locker is designed to be easy to debug.  You set the `DEBUG` environment variable and you'll get diagnostic information to `stderr`.  Every request and its response is logged.

    # Sample command that illustrates debug output
    DEBUG=true ./consul-locker --help

    # Or you can get a LOT of output when you run a real service
    DEBUG=true ./consul-locker test-service examples/10-second-wait

I encourage issues and pull requests, plus any additional scripts we can add to the [examples folder].

This code is licensed under an [MIT License] that has an additional non-advertising clause.


[Consul]: https://consul.io/
[Consul Agent HTTP API]: https://www.consul.io/docs/agent/http.html
[Examples Folder]: examples/
[MIT License]: LICENSE.md
