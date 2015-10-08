#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickCommandExists"
}

@test "lib/wickCommandExists: linux - exists" {
    mock-command which wickCommandExists/linux
    wickCommandExists ok
}

@test "lib/wickCommandExists: linux - does not exist" {
    mock-command which wickCommandExists/linux
    ! wickCommandExists bad
}
