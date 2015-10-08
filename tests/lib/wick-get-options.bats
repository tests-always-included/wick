#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickIndirectArray"
    . "$WICK_DIR/lib/wickGetOptions"
}

@test "lib/wickGetOptions: success" {
    local X

    wickGetOptions X zero no not me --option sky -b --key=23
    [[ "${#X[@]}" == 3 ]]
    [[ "${X[@]}" == "--option -b --key=23" ]]
}

@test "lib/wickGetOptions: no options" {
    local X

    wickGetOptions X
    [[ "${#X[@]}" == 0 ]]
}

@test "lib/wickGetOptions: mixed with arguments" {
    local X

    # Options after -- are treated as arguments
    wickGetOptions X --arg=one -a elephant --in=the room -- -x --y
    [[ "${#X[@]}" == 3 ]]
    [[ "${X[@]}" == "--arg=one -a --in=the" ]]
}
