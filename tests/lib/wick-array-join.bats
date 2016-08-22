#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-array-join"
}

@test "lib/wick-array-join: Create file path" {
    local arr actual

    arr=(
        my/path
        is-good
    )

    wickArrayJoin actual "/" "${arr[@]}"

    [[ "$actual" == my/path/is-good ]]
}
