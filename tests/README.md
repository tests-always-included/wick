Tests - Wick
============

The purpose behind Wick is to provide a cross-platform way of configuring machines and automating tasks, with a special focus on software installation and setup.  Having tests that ensure components work is critical to support this goal.  It is expected that one can run tests on a platform and feel reassured that Wick would run properly there.  Failing tests should include enough information to point to a function or an area in order to narrow the search for the issue to a smaller amount of code.

Docker should be used to ensure that Wick works in problematic environments.

The truth of the matter is that we just are not there yet.  Any pull requests to add coverage or create a stellar Bash-based testing framework would be hugely beneficial.


Directory Structure
-------------------

When possible, name your tests to match the files that they are testing.  This helps immensely when checking if something is covered well and when updating test cases.
