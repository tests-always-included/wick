#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickIndirect"
    . "$WICK_DIR/lib/wickSafeVariableName"
}

@test "lib/wickSafeVariableName: Normal name" {
    local OUT
    wickSafeVariableName OUT "Testing"
    [[ "$OUT" == "Testing" ]]
}

@test "lib/wickSafeVariableName: Invalid characters" {
    local OUT
    wickSafeVariableName OUT "One Two-Three"
    [[ "$OUT" == "One_Two_Three" ]]
}
