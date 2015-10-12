#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-safe-variable-name"
}

@test "lib/wick-safe-variable-name: Normal name" {
    local OUT
    wickSafeVariableName OUT "Testing"
    [[ "$OUT" == "Testing" ]]
}

@test "lib/wick-safe-variable-name: Invalid characters" {
    local OUT
    wickSafeVariableName OUT "One Two-Three"
    [[ "$OUT" == "One_Two_Three" ]]
}
