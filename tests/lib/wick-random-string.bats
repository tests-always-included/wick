#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickIndirect"
    . "$WICK_DIR/lib/wickRandomString"
}

@test "lib/wickRandomString: right length" {
    local OUT
    wickRandomString OUT
    [ "${#OUT}" -eq 1 ]
    wickRandomString OUT 20
    [ "${#OUT}" -eq 20 ]
    wickRandomString OUT 10
    [ "${#OUT}" -eq 10 ]
}

@test "lib/wickRandomString: randomized" {
    local ONE TWO
    wickRandomString ONE
    wickRandomString TWO
    [ "$ONE" != "$TWO" ]
}

@test "lib/wickRandomString: right characters" {
    local OUT
    wickRandomString OUT 10 A
    [ "$OUT" == "AAAAAAAAAA" ]
    wickRandomString OUT 30 ABC
    OUT=${OUT//A}
    OUT=${OUT//B}
    OUT=${OUT//C}
    [ "$OUT" == "" ]
}
