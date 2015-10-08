#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wickGetOption"
    . "$WICK_DIR/lib/wickIndirect"
    . "$WICK_DIR/lib/wickSafeVariableName"
    . "$WICK_DIR/lib/wickTestForOptions"
}

test-for-options-failure() {
    echo "Missing $ARG"
    FAILS=("${FAILS[@]}" "$ARG")
}

@test "lib/wickTestForOptions: Success" {
    FAILS=()
    WICK_TEST_FOR_OPTIONS_FAILURE=test-for-options-failure \
        wickTestForOptions one two -- thing --two --three --one
    echo "${#FAILS[@]}"
    [[ "${#FAILS[@]}" == 0 ]]
}

@test "lib/wickTestForOptions: Single failure" {
    FAILS=()
    ! WICK_TEST_FOR_OPTIONS_FAILURE=test-for-options-failure \
        wickTestForOptions one two -- thing one two --two --three
    [[ "${#FAILS[@]}" == 1 ]]
    [[ "${FAILS[0]}" == "one" ]]
}

@test "lib/wickTestForOptions: Multiple failures" {
    FAILS=()
    ! WICK_TEST_FOR_OPTIONS_FAILURE=test-for-options-failure \
        wickTestForOptions one two -- thing one two --too --three
    [[ "${#FAILS[@]}" == 2 ]]
    [[ "${FAILS[0]}" == "one" ]]
    [[ "${FAILS[1]}" == "two" ]]
}
