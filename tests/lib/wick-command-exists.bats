#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-command-exists"
}

@test "linux - exists" {
    mock-command which wick-command-exists/linux
    wick-command-exists ok
}

@test "linux - does not exist" {
    mock-command which wick-command-exists/linux
    ! wick-command-exists bad
}
