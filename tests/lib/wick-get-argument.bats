#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickIndirectArray"
    . "$WICK_DIR/lib/wickIndirect"
    . "$WICK_DIR/lib/wickGetArguments"
    . "$WICK_DIR/lib/wickGetArgument"
}

@test "lib/wickGetArgument: success" {
    local X

    wickGetArgument X 1 zero one two three
    [[ "$X" == "one" ]]
}

@test "lib/wickGetArgument: no arguments" {
    local X

    wickGetArgument X 1
    [[ "$X" == "" ]]
}

@test "lib/wickGetArgument: mixed with options" {
    local X

    # Options after -- are treated as arguments
    wickGetArgument X 1 --one=two -a -b --c moo -- --not-an-option cow
    [[ "$X" == "--not-an-option" ]]
}
