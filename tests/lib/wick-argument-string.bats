#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickIndirect"
    . "$WICK_DIR/lib/wickArgumentString"
}

@test "lib/wickArgumentString: simple" {
    local X

    wickArgumentString X "abc"
    [[ "$X" == "abc" ]]
}

@test "lib/wickArgumentString: space" {
    local X

    wickArgumentString X "a b"
    [[ "$X" == "a\\ b" ]]
}

@test "lib/wickArgumentString: single quote" {
    local X

    wickArgumentString X "a'b"
    [[ "$X" == "a\\'b" ]]
}

@test "lib/wickArgumentString: double quote" {
    local X

    wickArgumentString X "a\"b"
    [[ "$X" == "a\\\"b" ]]
}
