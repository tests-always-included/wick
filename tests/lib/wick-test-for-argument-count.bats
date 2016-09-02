#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-get-argument"
    . "$WICK_DIR/lib/wick-get-arguments"
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-indirect-array"
    . "$WICK_DIR/lib/wick-safe-variable-name"
    . "$WICK_DIR/lib/wick-test-for-argument-count"
}

@test "lib/wick-test-for-argument-count: Success" {
    wickTestForArgumentCount 3 one two three --option=test
}

@test "lib/wick-test-for-argument-count: Empty argument failure" {
    ! wickTestForArgumentCount 2 one ""
}

@test "lib/wick-test-for-argument-count: Too few arguments failure" {
    ! wickTestForArgumentCount 2 one --option --thing=stuff
}

@test "lib/wick-test-for-argument-count: Too many arguments failure" {
    ! wickTestForArgumentCount 2 one two three
}
