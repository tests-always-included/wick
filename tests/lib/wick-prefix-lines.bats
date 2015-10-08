#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickIndirect"
    . "$WICK_DIR/lib/wickPrefixLines"
}

@test "lib/wickPrefixLines: one line" {
    local OUT

    wickPrefixLines OUT "TEST 1:" "This is just a single line"
    [[ "$OUT" == "TEST 1:This is just a single line" ]]
}

@test "lib/wickPrefixLines: newlines" {
    local OUT

    # Newlines of any flavor are converted to \n
    # The prefix is added to each line.
    wickPrefixLines OUT "2:" $'dos\r\nunix\nold mac\r'
    [[ "$OUT" == $'2:dos\n2:unix\n2:old mac\n2:' ]]
}
