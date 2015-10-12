#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-in-array"
}

@test "lib/wick-in-array: none match" {
    ! wickInArray match a b c
}

@test "lib/wick-in-array: no array" {
    ! wickInArray match
}

@test "lib/wick-in-array: match" {
    wickInArray match a b c match d e f g h i j k
}
