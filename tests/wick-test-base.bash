#!/bin/bash
set -e

find-script-dir() {
    cd "$1"
    echo "$PWD"
}

TEST_DIR=$(find-script-dir "$PWD/${1%/*}")
WICK_DIR=${TEST_DIR%/*}
