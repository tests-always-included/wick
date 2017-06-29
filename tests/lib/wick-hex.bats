#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-hex"
    . "$WICK_DIR/lib/wick-indirect"
}

@test "lib/wick-hex: empty" {
    local X

    wickHex X ""
    [[ "$X" == "" ]]
}

@test "lib/wick-hex: not empty" {
    local X

    wickHex X $'abc\n123\n'
    [[ "$X" == "6162630a3132330a" ]]
}
