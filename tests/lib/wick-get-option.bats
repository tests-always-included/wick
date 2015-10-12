#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-safe-variable-name"
    . "$WICK_DIR/lib/wick-get-option"
}

@test "lib/wick-get-option: long option with value" {
    local X

    wickGetOption X opt zero --opt=1 -o
    [[ "$X" == "1" ]]
}

@test "lib/wick-get-option: long option without value" {
    local X

    wickGetOption X opt zero --opt -o
    [[ "$X" == "true" ]]
}

@test "lib/wick-get-option: short option with value" {
    local X

    wickGetOption X o zero --opt=1 -o
    [[ "$X" == "true" ]]
}

@test "lib/wick-get-option: prefer later arguments" {
    local X

    wickGetOption X test --test=1 --test=2
    [[ "$X" == "2" ]]
}

@test "lib/wick-get-option: no arguments" {
    local X

    wickGetOption X opt zero --miss=true -o
    [[ "$X" == "" ]]
}

@test "lib/wick-get-option: mixed with arguments" {
    local X

    # --one=three is not an option because it is after --
    wickGetOption X one --one=two -a -b --c moo -- cow --one=three
    [[ "$X" == two ]]
}
