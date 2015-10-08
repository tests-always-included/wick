#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickInArray"
}

@test "lib/wick-array-filter: none match" {
    ! wickInArray match a b c
}

@test "lib/wick-array-filter: no array" {
    ! wickInArray match
}

@test "lib/wick-array-filter: match" {
    wickInArray match a b c match d e f g h i j k
}
