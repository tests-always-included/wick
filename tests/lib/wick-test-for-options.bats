#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-get-option"
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-safe-variable-name"
    . "$WICK_DIR/lib/wick-test-for-options"
}

test-for-options-failure() {
    echo "Missing $ARG"
    FAILS=("${FAILS[@]}" "$ARG")
}

@test "lib/wick-test-for-options: Success" {
    FAILS=()
    WICK_TEST_FOR_OPTIONS_FAILURE=test-for-options-failure \
        wick-test-for-options one two -- thing --two --three --one
    echo "${#FAILS[@]}"
    [[ "${#FAILS[@]}" == 0 ]]
}

@test "lib/wick-test-for-options: Single failure" {
    FAILS=()
    ! WICK_TEST_FOR_OPTIONS_FAILURE=test-for-options-failure \
        wick-test-for-options one two -- thing one two --two --three
    [[ "${#FAILS[@]}" == 1 ]]
    [[ "${FAILS[0]}" == "one" ]]
}

@test "lib/wick-test-for-options: Multiple failures" {
    FAILS=()
    ! WICK_TEST_FOR_OPTIONS_FAILURE=test-for-options-failure \
        wick-test-for-options one two -- thing one two --too --three
    [[ "${#FAILS[@]}" == 2 ]]
    [[ "${FAILS[0]}" == "one" ]]
    [[ "${FAILS[1]}" == "two" ]]
}
