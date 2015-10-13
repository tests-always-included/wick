Deprecation
===========

The first draft of a research paper, book, or extensive article typically needs several revisions until it is considered "good enough to publish."  Even after publication, sometimes errors or inconsistencies are found and a later publication may have a typo fixed or wording made into something that's more clear.

The same is true for software.

Wick experiences continual changes and improvements.  When there are important changes, they will be listed here so that people who upgrade will have a reference of what changed between versions.

Newer items are added to the top.

### Standards

Naming standards were enforced for variables and functions.  This caused functions that were hyphenated to be changed to camel case.  For instance, `wick-indirect-array` is now `wickIndirectArray`.  Internal variables are no longer all caps and they are also camel case, though ones that are exported and intended to be used outside the function are still all caps.  `$FORMULA_LIST` is now `$formulaList`.

The old functions have been added to a list of deprecated functions.  The old name will continue to work for a while but will call `wickError` to display an error message to the screen indicating that a deprecated function was called.

The biggest snag is when you use `wick-init-d-lib` because it doesn't have the same mechanism in place for deprecated functions.  The newly named functions will be rewritten to call through to the hyphenated versions when those are defined, though you must call `handle-command` (the old function name) to enable this behavior.
