#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-in-array"
}

@test "lib/wick-array-filter: none match" {
    ! wick-in-array match a b c
}

@test "lib/wick-array-filter: no array" {
    ! wick-in-array match
}

@test "lib/wick-array-filter: match" {
    wick-in-array match a b c match d e f g h i j k
}
