#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-is-var-set"
}

@test "lib/wick-is-var-set: set to a value" {
    local X
    X="a value"
    wickIsVarSet X
}

@test "lib/wick-is-var-set: set to an empty string" {
    local X
    X=""
    wickIsVarSet X
}

@test "lib/wick-is-var-set: unset" {
    local X
    unset X
    ! wickIsVarSet X
}
