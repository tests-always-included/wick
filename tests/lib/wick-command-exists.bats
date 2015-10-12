#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-command-exists"
}

@test "lib/wick-command-exists: linux - exists" {
    mock-command which wick-command-exists/linux
    wickCommandExists ok
}

@test "lib/wick-command-exists: linux - does not exist" {
    mock-command which wick-command-exists/linux
    ! wickCommandExists bad
}
