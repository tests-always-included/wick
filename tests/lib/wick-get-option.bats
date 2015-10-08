#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickIndirect"
    . "$WICK_DIR/lib/wickSafeVariableName"
    . "$WICK_DIR/lib/wickGetOption"
}

@test "lib/wickGetOption: long option with value" {
    local X

    wickGetOption X opt zero --opt=1 -o
    [[ "$X" == "1" ]]
}

@test "lib/wickGetOption: long option without value" {
    local X

    wickGetOption X opt zero --opt -o
    [[ "$X" == "true" ]]
}

@test "lib/wickGetOption: short option with value" {
    local X

    wickGetOption X o zero --opt=1 -o
    [[ "$X" == "true" ]]
}

@test "lib/wickGetOption: prefer later arguments" {
    local X

    wickGetOption X test --test=1 --test=2
    [[ "$X" == "2" ]]
}

@test "lib/wickGetOption: no arguments" {
    local X

    wickGetOption X opt zero --miss=true -o
    [[ "$X" == "" ]]
}

@test "lib/wickGetOption: mixed with arguments" {
    local X

    # --one=three is not an option because it is after --
    wickGetOption X one --one=two -a -b --c moo -- cow --one=three
    [[ "$X" == two ]]
}
