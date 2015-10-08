Rvm
===

This installs RVM from [http://get.rvm.io/](http://get.rvm.io/).  Passes all extra parameters to the installer.

    wickFormula rvm OPTIONS

* `OPTIONS`: Installer options, passed directly to the installer.  See [https://rvm.io/rvm/install](https://rvm.io/rvm/install) for some examples.

Example:

    # Install RVM and the latest Ruby
    wickFormula rvm stable --ruby=latest
