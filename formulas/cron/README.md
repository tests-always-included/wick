Cron
====

This formula does not perform any action.  It exists only to add useful functions to the Wick environment.

    wickFormula cron


Functions
---------

### cron-add

Add a job to cron.  Takes additional arguments and passes them to `wickMakeFile` from [wick-base].

    cron-add [WICK_MAKE_FILE_ARGS] JOB_NAME FILE

* `WICK_MAKE_FILE_ARGS`: Additional arguments as understood by `wickMakeFile` from [wick-base].  These arguments can be placed anywhere in the argument list.
* `JOB_NAME`: Name of the cron job to create.  For best results, try to avoid characters that make regular expressions hard or ones that do not work well as filenames.  For example, `*super* job!` is a bad name, `super-job` is far better.
* `FILE`: File to use for the cron job.  If `--template` is used, this can be a [template]. This might be placed into a new file or appended to a list of cron jobs in one file, so it is best to avoid setting environment variables.

File contents need to have the following fields for a job definition, in order:  minute, hour, day, day of month, month, day of week, username, command.  For more information, see `man 5 crontab` and remember that these are system jobs so they require an account name.

Example:

    # Adds a job from files/delete_files.cron
    cron-add delete_files delete_files.cron


### cron-remove

Removes a job from cron.  Works only for jobs that were added with `cron-add`.

    cron-remove JOB_NAME

* `JOB_NAME`: Name of the cron job to remove.

Example:

    # Add and remove a cron job
    cron-add update-mongo-v2 --template update-mongo.mo
    cron-remove update-mongo-v1


[template]: ../../doc/templates.md
[wick-base]: ../wick-base/README.md
