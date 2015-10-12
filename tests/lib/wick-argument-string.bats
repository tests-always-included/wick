#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-argument-string"
}

@test "lib/wick-argument-string: simple" {
    local X

    wickArgumentString X "abc"
    [[ "$X" == "abc" ]]
}

@test "lib/wick-argument-string: space" {
    local X

    wickArgumentString X "a b"
    [[ "$X" == "a\\ b" ]]
}

@test "lib/wick-argument-string: single quote" {
    local X

    wickArgumentString X "a'b"
    [[ "$X" == "a\\'b" ]]
}

@test "lib/wick-argument-string: double quote" {
    local X

    wickArgumentString X "a\"b"
    [[ "$X" == "a\\\"b" ]]
}
