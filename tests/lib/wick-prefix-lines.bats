#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-prefix-lines"
}

@test "lib/wick-prefix-lines: one line" {
    local OUT

    wick-prefix-lines OUT "TEST 1:" "This is just a single line"
    [[ "$OUT" == "TEST 1:This is just a single line" ]]
}

@test "lib/wick-prefix-lines: newlines" {
    local OUT

    # Newlines of any flavor are converted to \n
    # The prefix is added to each line.
    wick-prefix-lines OUT "2:" $'dos\r\nunix\nold mac\r'
    [[ "$OUT" == $'2:dos\n2:unix\n2:old mac\n2:' ]]
}
