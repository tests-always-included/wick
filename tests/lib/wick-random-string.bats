#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-random-string"
}

@test "lib/wick-random-string: right length" {
    local OUT
    wickRandomString OUT
    [ "${#OUT}" -eq 1 ]
    wickRandomString OUT 20
    [ "${#OUT}" -eq 20 ]
    wickRandomString OUT 10
    [ "${#OUT}" -eq 10 ]
}

@test "lib/wick-random-string: randomized" {
    local ONE TWO
    wickRandomString ONE
    wickRandomString TWO
    [ "$ONE" != "$TWO" ]
}

@test "lib/wick-random-string: right characters" {
    local OUT
    wickRandomString OUT 10 A
    [ "$OUT" == "AAAAAAAAAA" ]
    wickRandomString OUT 30 ABC
    OUT=${OUT//A}
    OUT=${OUT//B}
    OUT=${OUT//C}
    [ "$OUT" == "" ]
}
