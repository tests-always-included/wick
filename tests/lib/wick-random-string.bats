#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-random-string"
}

@test "right length" {
    local OUT
    wick-random-string OUT
    [ "${#OUT}" -eq 1 ]
    wick-random-string OUT 20
    [ "${#OUT}" -eq 20 ]
    wick-random-string OUT 10
    [ "${#OUT}" -eq 10 ]
}

@test "randomized" {
    local ONE TWO
    wick-random-string ONE
    wick-random-string TWO
    [ "$ONE" != "$TWO" ]
}

@test "right characters" {
    local OUT
    wick-random-string OUT 10 A
    [ "$OUT" == "AAAAAAAAAA" ]
    wick-random-string OUT 30 ABC
    OUT=${OUT//A}
    OUT=${OUT//B}
    OUT=${OUT//C}
    [ "$OUT" == "" ]
}
