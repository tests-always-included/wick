#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect-array"
    . "$WICK_DIR/lib/wick-get-arguments"
}

@test "lib/wick-get-arguments: success" {
    local X

    wickGetArguments X zero one two
    [[ "${#X[@]}" == 3 ]]
    [[ "${X[@]}" == "zero one two" ]]
}

@test "lib/wick-get-arguments: no arguments" {
    local X

    wickGetArguments X
    [[ "${#X[@]}" == 0 ]]
}

@test "lib/wick-get-arguments: mixed with options" {
    local X

    # Options after -- are treated as arguments
    wickGetArguments X --arg=one -a elephant --in=the room -- -x --y
    [[ "${#X[@]}" == 4 ]]
    [[ "${X[@]}" == "elephant room -x --y" ]]
}
