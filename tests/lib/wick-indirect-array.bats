#!../bats/bats

setup() {
    load ../wick-test-base
    . "$WICK_DIR/lib/wick-indirect-array"
}

test-one-level() {
    local RESULT

    test-one-level-set RESULT

    echo "${RESULT[@]}"
}

test-one-level-set() {
    local "$1" && wick-indirect-array "$1" one two three
}

@test "lib/wick-indirect: one level" {
    [ "$(test-one-level)" == "one two three" ]
}

test-conflicting-variables() {
    local AAA

    AAA="before"
    test-conflicting-variables-set1 AAA
    echo "${AAA[@]}"
}

test-conflicting-variables-set1() {
    local AAA

    AAA=(wrong data)
    test-conflicting-variables-set2 AAA
    AAA=("${AAA[@]}" "+set1")
    local "$1" && wick-indirect-array "$1" "${AAA[@]}"
}

test-conflicting-variables-set2() {
    local AAA

    AAA="set2-before"
    local "$1" && wick-indirect-array "$1" set2a set2b
}

@test "lib/wick-indirect: conflicting variables" {
    [ "$(test-conflicting-variables)" == "set2a set2b +set1" ]
}
