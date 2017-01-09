#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect"
    . "$WICK_DIR/lib/wick-strict-run"
}

failingFunction() {
    false
    true
}

@test "lib/wick-strict-run: captures return code from binary without strict mode" {
    local result

    wickStrictRun result "$(which false)"
    [[ "$result" -ne 0 ]]
}

@test "lib/wick-strict-run: captures return code from binary with strict mode" {
    local result

    set -eE -o pipefail
    wickStrictRun result "$(which false)"
    [[ "$result" -ne 0 ]]
}

@test "lib/wick-strict-run: captures return code from function without strict mode" {
    local result

    wickStrictRun result failingFunction
    [[ "$result" -ne 0 ]]
}

@test "lib/wick-strict-run: captures return code from function with strict mode" {
    local result

    set -eE -o pipefail
    wickStrictRun result failingFunction
    [[ "$result" -ne 0 ]]
}
