#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect-array"
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-get-arguments"
    . "$WICK_DIR/lib/wick-get-argument"
}

@test "lib/wick-get-argument: success" {
    local X

    wick-get-argument X 1 zero one two three
    [[ "$X" == "one" ]]
}

@test "lib/wick-get-argument: no arguments" {
    local X

    wick-get-argument X 1
    [[ "$X" == "" ]]
}

@test "lib/wick-get-argument: mixed with options" {
    local X

    # Options after -- are treated as arguments
    wick-get-argument X 1 --one=two -a -b --c moo -- --not-an-option cow
    [[ "$X" == "--not-an-option" ]]
}
